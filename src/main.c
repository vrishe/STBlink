#include "stm32f1xx.h"

#include <stdint.h>

void main(void) {

  // SYSCLK @ 8MHz HSE is more than enough, no need to engage PLL.
  SET_BIT(RCC->CR, RCC_CR_HSEON);
  while (!READ_BIT(RCC->CR, RCC_CR_HSERDY));
  CLEAR_BIT(RCC->CR, RCC_CR_HSION);
  SystemCoreClockUpdate();

  uint32_t dummy;

  // Disable JTAG, keep SWD only
  SET_BIT(RCC->APB2ENR, RCC_APB2ENR_AFIOEN);
  dummy = READ_BIT(RCC->APB2ENR, RCC_APB2ENR_AFIOEN);
  MODIFY_REG(AFIO->MAPR, AFIO_MAPR_SWJ_CFG, AFIO_MAPR_SWJ_CFG_JTAGDISABLE);

  // Setup PC13
  SET_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
  dummy = READ_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPCEN);
  MODIFY_REG(GPIOC->CRH, GPIO_CRH_CNF13, GPIO_CRH_MODE13);

  // 4Hz interrupt rate => 2Hz blink rate.
  SysTick_Config(SystemCoreClock / 4);
  __enable_irq();

  for(;;);
}

void SysTick_Handler() {
  uint32_t pin_state = ~(READ_BIT(GPIOC->IDR, GPIO_IDR_IDR13)
    >> GPIO_IDR_IDR13_Pos) + 1;
  SET_BIT(GPIOC->BSRR, pin_state & GPIO_BSRR_BR13
    | ~pin_state & GPIO_BSRR_BS13);
}