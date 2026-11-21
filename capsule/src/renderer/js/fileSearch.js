// Local File Search
class FileSearch {
  constructor(inputElem, resultsBox, resultsList) {
    this.inputElem = inputElem;
    this.resultsBox = resultsBox;
    this.resultsList = resultsList;
    this.debounceTimer = null;
    this.init();
  }

  init() {
    this.inputElem.addEventListener('input', (e) => {
      clearTimeout(this.debounceTimer);
      const query = e.target.value.trim();
      if (!query) {
        this.resultsBox.style.display = 'none';
        return;
      }
      this.debounceTimer = setTimeout(() => this.search(query), 300);
    });
  }

  async search(query) {
    if (!window.capsuleAPI?.searchFiles) return;
    try {
      const results = await window.capsuleAPI.searchFiles(query);
      this.render(results);
    } catch (_) {
      this.resultsBox.style.display = 'none';
    }
  }

  render(files) {
    if (!files || files.length === 0) {
      this.resultsBox.style.display = 'block';
      this.resultsList.innerHTML = '<div class="file-item"><span class="file-name">No matching files found.</span></div>';
      return;
    }

    this.resultsBox.style.display = 'block';
    this.resultsList.innerHTML = '';

    files.forEach((file) => {
      const item = document.createElement('div');
      item.className = 'file-item';

      const icon = document.createElement('span');
      icon.textContent = file.isDirectory ? '📁' : '📄';

      const name = document.createElement('span');
      name.className = 'file-name';
      name.textContent = file.name;
      name.title = file.path;

      item.appendChild(icon);
      item.appendChild(name);

      item.addEventListener('click', () => {
        window.capsuleAPI.openFile(file.path);
      });

      this.resultsList.appendChild(item);
    });
  }
}

window.FileSearch = FileSearch;
