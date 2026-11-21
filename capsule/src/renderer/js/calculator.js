// Scientific Calculator & Unit Converter
class Calculator {
  constructor(displayElem, historyElem) {
    this.displayElem = displayElem;
    this.historyElem = historyElem;
    this.currentExpr = '0';
    this.evaluated = false;
  }

  handleInput(action) {
    if (action === 'C') {
      this.currentExpr = '0';
      this.historyElem.textContent = '';
      this.evaluated = false;
    } else if (action === 'DEL') {
      if (this.currentExpr.length > 1) {
        this.currentExpr = this.currentExpr.slice(0, -1);
      } else {
        this.currentExpr = '0';
      }
    } else if (action === '=') {
      this.calculate();
    } else if (['sin', 'cos', 'tan', 'sqrt'].includes(action)) {
      if (this.currentExpr === '0' || this.evaluated) {
        this.currentExpr = `${action}(`;
        this.evaluated = false;
      } else {
        this.currentExpr += `${action}(`;
      }
    } else if (action === 'pi') {
      if (this.currentExpr === '0' || this.evaluated) {
        this.currentExpr = Math.PI.toFixed(4);
        this.evaluated = false;
      } else {
        this.currentExpr += Math.PI.toFixed(4);
      }
    } else {
      // Normal numbers and operators
      if ((this.currentExpr === '0' && action !== '.') || this.evaluated) {
        if (['+', '-', '*', '/'].includes(action)) {
          this.currentExpr += action;
        } else {
          this.currentExpr = action;
        }
        this.evaluated = false;
      } else {
        this.currentExpr += action;
      }
    }

    this.displayElem.value = this.currentExpr;
  }

  calculate() {
    try {
      this.historyElem.textContent = `${this.currentExpr} =`;
      // Safely replace mathematical functions with Math equivalents
      let expr = this.currentExpr
        .replace(/sin\(/g, 'Math.sin(')
        .replace(/cos\(/g, 'Math.cos(')
        .replace(/tan\(/g, 'Math.tan(')
        .replace(/sqrt\(/g, 'Math.sqrt(');

      // Validate characters to prevent arbitrary code execution
      if (!/^[0-9+\-*/().\sMathsincotarqp]+$/.test(expr)) {
        throw new Error('Invalid syntax');
      }

      const result = Function(`'use strict'; return (${expr})`)();
      this.currentExpr = String(Math.round(result * 100000) / 100000);
      this.evaluated = true;
    } catch (_) {
      this.currentExpr = 'Error';
      this.evaluated = true;
    }
    this.displayElem.value = this.currentExpr;
  }
}

window.Calculator = Calculator;
