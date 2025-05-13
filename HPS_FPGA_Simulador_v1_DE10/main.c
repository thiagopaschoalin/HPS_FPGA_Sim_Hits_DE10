#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int main() {
    void *virtual_base;
    int fd;
    void *h2p_lw_led_addr;
    uint32_t led_value;

    // Abre /dev/mem
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("ERROR: it cannot open \"/dev/mem\"...\n");
        return 1;
    }

    // Faz o mapeamento da memória física
    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if (virtual_base == MAP_FAILED) {
        printf("ERROR: mmap() falied...\n");
        close(fd);
        return 1;
    }

    // Calcula o endereço dos LEDs
    h2p_lw_led_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + LED_PIO_BASE) & (unsigned long)(HW_REGS_MASK));

    // Loop de entrada
    while (1) {
        printf("Enter a integer value between 0 -0%%- and 127 -100%%- for the occupancy -Ctrl+C to exit-: ");
        if (scanf("%u", &led_value) == 1) {
            // Limita o valor a 8 bits, se necessário
            led_value &= 0xFFFF;
            // Escreve o valor nos LEDs
            *(uint32_t *)h2p_lw_led_addr = led_value;
        } else {
            // Limpa buffer se entrada for inválida
            while (getchar() != '\n');
            printf("Invalid Enter. Try again.\n");
        }
    }

    // Libera o mapeamento (nunca chegará aqui a menos que o loop seja interrompido)
    munmap(virtual_base, HW_REGS_SPAN);
    close(fd);
    return 0;
}
