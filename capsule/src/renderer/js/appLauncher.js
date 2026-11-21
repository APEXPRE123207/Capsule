// Application Launcher Grid
class AppLauncher {
  constructor(gridElem) {
    this.gridElem = gridElem;
    this.apps = [];
    this.init();
  }

  async init() {
    if (!window.capsuleAPI?.getInstalledApps) return;
    try {
      this.apps = await window.capsuleAPI.getInstalledApps();
      this.render();
    } catch (_) {}
  }

  render() {
    this.gridElem.innerHTML = '';
    this.apps.forEach((app) => {
      const card = document.createElement('div');
      card.className = 'app-card';
      card.title = `Launch ${app.name}`;

      const icon = document.createElement('span');
      icon.className = 'app-card-icon';
      icon.textContent = app.icon || '🚀';

      const name = document.createElement('span');
      name.className = 'app-card-name';
      name.textContent = app.name;

      card.appendChild(icon);
      card.appendChild(name);

      card.addEventListener('click', () => {
        window.capsuleAPI.launchApp(app.path);
      });

      this.gridElem.appendChild(card);
    });
  }
}

window.AppLauncher = AppLauncher;
