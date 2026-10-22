#include <fcntl.h>
#include <linux/spi/spidev.h> // Contains SPI ioctl macros
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define SPI_DEVICE "/dev/spidev0.0"

int main(void) {
  int fd;

  // SPI Configuration variables
  uint8_t mode = SPI_MODE_0; // CPOL=0, CPHA=0
  uint8_t bits = 8;          // 8 bits per word
  uint32_t speed = 1000000;  // 1 MHz clock speed

  // 1. Open the SPI device file
  fd = open(SPI_DEVICE, O_RDWR);
  if (fd < 0) {
    perror("Failed to open SPI device");
    return EXIT_FAILURE;
  }

  // 2. Configure the SPI Bus using ioctl
  if (ioctl(fd, SPI_IOC_WR_MODE, &mode) < 0) {
    perror("Failed to set SPI mode");
    close(fd);
    return EXIT_FAILURE;
  }

  if (ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0) {
    perror("Failed to set bits per word");
    close(fd);
    return EXIT_FAILURE;
  }

  if (ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0) {
    perror("Failed to set max speed");
    close(fd);
    return EXIT_FAILURE;
  }

  // 3. Prepare data buffers
  uint8_t tx_buf[] = {0x48, 0x65, 0x6C, 0x6C, 0x6F}; // "Hello" in hex
  uint8_t rx_buf[sizeof(tx_buf)] = {0};
  uint32_t len = sizeof(tx_buf);

  // 4. Define the SPI transfer structure
  struct spi_ioc_transfer tr = {
      .tx_buf = (unsigned long)tx_buf,
      .rx_buf = (unsigned long)rx_buf,
      .len = len,
      .speed_hz = speed,
      .bits_per_word = bits,
      .delay_usecs = 0,
      .cs_change = 0, // Keep Chip Select asserted throughout the transfer
  };

  printf("Sending hex: ");
  for (uint32_t i = 0; i < len; i++) {
    printf("0x%02X ", tx_buf[i]);
  }
  printf("\n");

  // 5. Execute the full-duplex transfer
  if (ioctl(fd, SPI_IOC_MESSAGE(1), &tr) < 0) {
    perror("SPI transfer failed");
    close(fd);
    return EXIT_FAILURE;
  }

  // 6. Print the received data
  printf("Received hex: ");
  for (uint32_t i = 0; i < len; i++) {
    printf("0x%02X ", rx_buf[i]);
  }
  printf("\n");

  // 7. Clean up file descriptor
  close(fd);
  return EXIT_SUCCESS;
}
