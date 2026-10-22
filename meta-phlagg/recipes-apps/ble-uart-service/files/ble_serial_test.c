#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#define BLE_DEVICE "/dev/ble_serial"
#define BUFFER_SIZE 256

int main(void) {
  int fd;
  struct termios options;
  struct pollfd fds[2];
  char buffer[BUFFER_SIZE];
  ssize_t bytes_read;

  // 1. Open the virtual serial port file
  // O_NOCTTY: Prevents the port from becoming the controlling terminal
  fd = open(BLE_DEVICE, O_RDWR | O_NOCTTY);
  if (fd < 0) {
    perror("Failed to open virtual COM port");
    printf("Hint: Ensure your BLE daemon or socat bridge is running and has "
           "created %s\n",
           BLE_DEVICE);
    return EXIT_FAILURE;
  }

  // 2. Configure the TTY line settings (Standard Raw Serial)
  tcgetattr(fd, &options);
  cfmakeraw(&options); // Put the port in raw binary communication mode
  options.c_cflag |=
      (CLOCAL | CREAD); // Enable receiver, ignore modem control lines
  tcsetattr(fd, TCSANOW, &options);

  printf("Successfully connected to %s\n", BLE_DEVICE);
  printf("Type anything to send data, or wait to receive incoming BLE "
         "data...\n\n");

  // 3. Set up the non-blocking polling event loop
  // Monitor both the BLE virtual serial port and your terminal's standard input
  // (keyboard)
  fds[0].fd = fd;         // BLE Virtual Port
  fds[0].events = POLLIN; // Look for incoming data to read

  fds[1].fd = STDIN_FILENO; // Keyboard Console input
  fds[1].events = POLLIN;   // Look for user typing

  while (1) {
    // Wait indefinitely (timeout = -1) until data arrives on either file
    // descriptor
    int poll_status = poll(fds, 2, -1);
    if (poll_status < 0) {
      perror("Poll error");
      break;
    }

    // Event A: Data received from the BLE stream
    if (fds[0].revents & POLLIN) {
      memset(buffer, 0, sizeof(buffer));
      bytes_read = read(fd, buffer, sizeof(buffer) - 1);
      if (bytes_read > 0) {
        printf("[Incoming BLE]: %s", buffer);
        fflush(stdout);
      } else if (bytes_read == 0) {
        printf("\nVirtual COM port disconnected.\n");
        break;
      }
    }

    // Event B: User typed text into the terminal console
    if (fds[1].revents & POLLIN) {
      memset(buffer, 0, sizeof(buffer));
      bytes_read = read(STDIN_FILENO, buffer, sizeof(buffer) - 1);
      if (bytes_read > 0) {
        // Transmit whatever you typed straight out through the virtual BLE port
        write(fd, buffer, bytes_read);
      }
    }
  }

  // 4. Clean up
  close(fd);
  return EXIT_SUCCESS;
}
