#include "stm32f1xx.h"

#include <stdint.h>

#define LED_PIN 13

static volatile uint32_t led_state = 0;

void main(void) {

  RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;
  GPIOC->CRH = GPIOC->CRH
    & ~(GPIO_CRH_MODE13_Msk|GPIO_CRH_CNF13_Msk)
    |  ((0 << GPIO_CRH_CNF13_Pos)|(2 << GPIO_CRH_MODE13_Pos));

  // SYSCLK @ 8MHz HSE is more than enough, no need to engage PLL.
  RCC->CR |= RCC_CR_HSEON;
  while (!(RCC->CR & RCC_CR_HSERDY));
  RCC->CR &= ~(RCC_CR_HSION);
  SystemCoreClockUpdate();

  // 4Hz interrupt rate => 2Hz blink rate.
  SysTick_Config(2000000);
  __enable_irq();

  for(;;);
}

void SysTick_Handler() {
  GPIOC->BSRR = (led_state ^= 1)
    ? (1 << LED_PIN) << 16
    : (1 << LED_PIN);
}