// Clipboard History Manager
class ClipboardManager {
  constructor(listElem, clearBtn) {
    this.listElem = listElem;
    this.clearBtn = clearBtn;
    this.history = [];
    this.lastItem = null;
    this.init();
  }

  init() {
    this.clearBtn.addEventListener('click', () => {
      this.history = [];
      this.render();
    });

    // Periodically poll for clipboard updates
    setInterval(() => this.checkClipboard(), 1500);
    this.checkClipboard();
  }

  async checkClipboard() {
    if (!window.capsuleAPI?.readClipboard) return;
    try {
      const text = await window.capsuleAPI.readClipboard();
      if (text && text.trim().length > 0 && text !== this.lastItem) {
        this.lastItem = text;
        this.addItem(text);
      }
    } catch (_) {}
  }

  addItem(text) {
    // Keep top 20 distinct items
    this.history = [text, ...this.history.filter((i) => i !== text)].slice(0, 20);
    this.render();
  }

  render() {
    if (this.history.length === 0) {
      this.listElem.innerHTML = '<div class="clipboard-empty">Clipboard history is empty.</div>';
      return;
    }

    this.listElem.innerHTML = '';
    this.history.forEach((item) => {
      const card = document.createElement('div');
      card.className = 'clipboard-card';

      const span = document.createElement('span');
      span.className = 'clipboard-text';
      span.textContent = item;

      const copyBtn = document.createElement('button');
      copyBtn.className = 'clipboard-copy-btn';
      copyBtn.textContent = 'Copy';
      copyBtn.addEventListener('click', async (e) => {
        e.stopPropagation();
        await window.capsuleAPI.writeClipboard(item);
        copyBtn.textContent = 'Copied!';
        setTimeout(() => {
          copyBtn.textContent = 'Copy';
        }, 1200);
      });

      card.appendChild(span);
      card.appendChild(copyBtn);
      this.listElem.appendChild(card);
    });
  }
}

window.ClipboardManager = ClipboardManager;
