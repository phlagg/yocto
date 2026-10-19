#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

// Helper to configure terminal raw input mode
void set_terminal_raw(int enable) {
    static struct termios oldt, newt;
    if (enable) {
        tcgetattr(STDIN_FILENO, &oldt);
        newt = oldt;
        newt.c_lflag &= ~(ICANON | ECHO); // Disable buffering and local echo
        tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    } else {
        tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    }
}

// Check if a keyboard key has been pressed (non-blocking)
int kbhit(void) {
    struct timeval tv = {0L, 0L};
    fd_set fds;
    FD_ZERO(&fds);
    FD_SET(STDIN_FILENO, &fds);
    return select(STDIN_FILENO + 1, &fds, NULL, NULL, &tv);
}

void draw_interface(int selection) {
    // Clear screen and move cursor to top-left
    printf("\033[2J\033[H");
    printf("==================================================\n");
    printf("     PHLAGG'S EMBEDDED RASPBERRY PI CONTROL       \n");
    printf("==================================================\n\n");
    printf(" Select an action using UP/DOWN or '1'-'3' keys:\n\n");

    printf("  %s [1] System Status Overview\n", (selection == 0) ? "-->" : "   ");
    printf("  %s [2] Network Diagnostic Panel\n", (selection == 1) ? "-->" : "   ");
    printf("  %s [3] Restart Core Application\n", (selection == 2) ? "-->" : "   ");

    printf("\n--------------------------------------------------\n");
    printf(" Press [Q] to Exit | Selection: %d\n", selection + 1);
    fflush(stdout);
}

int main(void) {
    int selection = 0;
    char ch = 0;
    int running = 1;

    set_terminal_raw(1);
    draw_interface(selection);

    while(running) {
        if (kbhit()) {
            ch = getchar();

            // Handle standard navigation controls
            if (ch == 'q' || ch == 'Q') {
                running = 0;
            } else if (ch == '1') {
                selection = 0;
                draw_interface(selection);
            } else if (ch == '2') {
                selection = 1;
                draw_interface(selection);
            } else if (ch == '3') {
                selection = 2;
                draw_interface(selection);
            }
            // Handle arrow keys tracking sequences (\033[A or \033[B)
            else if (ch == '\033') {
                getchar(); // Skip the '['
                switch(getchar()) {
                    case 'A': // UP arrow
                        selection = (selection - 1 + 3) % 3;
                        draw_interface(selection);
                        break;
                    case 'B': // DOWN arrow
                        selection = (selection + 1) % 3;
                        draw_interface(selection);
                        break;
                }
            }
        }
        usleep(50000); // 50ms sleep to conserve CPU usage loops
    }

    set_terminal_raw(0);
    printf("\033[2J\033[HTerminal mode restored. Exiting.\n");
    return 0;
}
