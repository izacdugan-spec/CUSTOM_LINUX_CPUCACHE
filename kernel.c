#define VGA_ADDRESS 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

typedef void (*user_space_func_t)(void);

void k_print(const char* str, int row, int col, unsigned char color) {
  volatile char* video_memory = (volatile char*)VGA_ADDRESS;
  int offset = (row * SCREEN_WIDTH + col) * 2;

  for(int i = 0; str[i] != '\0'; i++) {
    video_memory[offset] = str[i];
    video_memory[offset + 1] = color;
    offset += 2;
  }
}

void k_clear_screen(unsigned char color) {
  volatile char* video_memory = (volatile char*)VGA_ADDRESS;
  int total_cells = SCREEN_WIDTH * SCREEN_HEIGHT * 2;

  for (int i = 0; i < total_cells; i += 2) {
    video_memory[i] = ' ';
    video_memory[i + 1] = color;
  }
}

void kernel_main(void) {
  k_print("OS LOADING: BOOT SEQUENCE INITIATED", 2, 5, 0x1E);
  k_print("STATUE: OS LOADED TO RAM SUCCESSFULLY", 4, 5, 0x1F);
  k_print("INITRD: 4MB ISOLATED SUCCESSFULLY", 5, 5, 0x1F);
  k_print("USERSPACE PALLETE PATHS DETECTED AT CACHE LINE 0", 7, 5, 0x1B);

  k_print("READY, LAUNCHING RAM DSKTP TRMNL", 10, 5, 0x1A);

  //now put all your userspace data here following this
  //(assuming the shell stuff is already compiled and loaded to a memory buffer)
  //user_space_func_t launch_shell = (user_space_func_t)0x00210000;
  //launch_shell();

  while (1) {
    asm volatile ("hlt");
  }
}
