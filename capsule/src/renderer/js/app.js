// Capsule Main Application Bootstrap & Logic
document.addEventListener('DOMContentLoaded', async () => {
  const islandElem = document.getElementById('capsule-island');
  const islandCtrl = new IslandController(islandElem);

  // 1. Clock in Idle State
  const idleClock = document.getElementById('idle-clock');
  function updateClock() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    idleClock.textContent = `${hours}:${minutes}`;
  }
  updateClock();
  setInterval(updateClock, 1000);

  // 2. Normal Window Closing & Minimizing Handlers (Exit Guarantee)
  const closeBtns = [
    document.getElementById('expanded-close-btn'),
    document.getElementById('max-close-btn'),
    document.getElementById('settings-exit-btn'),
  ];
  closeBtns.forEach((btn) => {
    if (btn) {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        if (window.capsuleAPI?.exitApp) {
          window.capsuleAPI.exitApp();
        }
      });
    }
  });

  const minBtns = [
    document.getElementById('expanded-min-btn'),
    document.getElementById('max-min-btn'),
  ];
  minBtns.forEach((btn) => {
    if (btn) {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        islandCtrl.collapseToIdle();
      });
    }
  });

  // State transitions: Expand & Collapse
  document.getElementById('expanded-expand-btn').addEventListener('click', (e) => {
    e.stopPropagation();
    islandCtrl.setState('max-expand');
  });

  document.getElementById('max-collapse-btn').addEventListener('click', (e) => {
    e.stopPropagation();
    islandCtrl.collapseToIdle();
  });

  // 3. Tab Switching in Max-Expand State
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanes = document.querySelectorAll('.tab-pane');
  tabBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      tabBtns.forEach((b) => b.classList.remove('active'));
      tabPanes.forEach((p) => p.classList.remove('active'));

      btn.classList.add('active');
      const targetTab = document.getElementById(`tab-${btn.dataset.tab}`);
      if (targetTab) targetTab.classList.add('active');
    });
  });

  // 4. Media & Lyrics Integration
  let currentTrack = {
    title: 'Starboy (feat. Daft Punk)',
    artist: 'The Weeknd',
    album: 'Starboy',
    duration: 230,
    position: 84,
    isPlaying: true,
    source: 'Spotify',
  };
  let activeLyrics = [];

  const idleText = document.getElementById('idle-status-text');
  const hoverMarquee = document.getElementById('hover-marquee-text');
  const expandedTitle = document.getElementById('expanded-track-title');
  const expandedArtist = document.getElementById('expanded-track-artist');
  const expandedSource = document.getElementById('expanded-source-name');
  const lyricsTitle = document.getElementById('lyrics-title');
  const lyricsArtist = document.getElementById('lyrics-artist');
  const lyricsListElem = document.getElementById('lyrics-list');
  const progressBar = document.getElementById('expanded-progress-bar');
  const timeCurrent = document.getElementById('expanded-time-current');
  const timeTotal = document.getElementById('expanded-time-total');

  function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${String(secs).padStart(2, '0')}`;
  }

  function renderLyrics() {
    lyricsListElem.innerHTML = '';
    activeLyrics.forEach((line) => {
      const lineElem = document.createElement('div');
      lineElem.className = 'lyric-item';
      lineElem.textContent = line.text;
      lineElem.dataset.timeMs = line.time_ms;
      lyricsListElem.appendChild(lineElem);
    });
  }

  function updateActiveLyricLine(posMs) {
    const items = lyricsListElem.querySelectorAll('.lyric-item');
    let activeElem = null;

    items.forEach((item) => {
      const lineMs = Number(item.dataset.timeMs);
      if (lineMs <= posMs) {
        activeElem = item;
      }
      item.classList.remove('active');
    });

    if (activeElem) {
      activeElem.classList.add('active');
      activeElem.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }

  async function loadLyrics(title, artist) {
    if (window.LyricsParser) {
      activeLyrics = await window.LyricsParser.fetchFromLrclib(title, artist);
      renderLyrics();
    }
  }

  async function syncMedia() {
    if (!window.capsuleAPI?.getCurrentTrack) return;
    try {
      const track = await window.capsuleAPI.getCurrentTrack();
      if (track) {
        if (track.title !== currentTrack.title || track.artist !== currentTrack.artist) {
          currentTrack = track;
          idleText.textContent = track.title;
          hoverMarquee.textContent = `${track.artist} — ${track.title}`;
          expandedTitle.textContent = track.title;
          expandedArtist.textContent = track.artist;
          expandedSource.textContent = track.source || 'Media';
          lyricsTitle.textContent = track.title;
          lyricsArtist.textContent = track.artist;
          loadLyrics(track.title, track.artist);
        }

        // Progress simulation
        if (currentTrack.isPlaying) {
          currentTrack.position = (currentTrack.position + 1) % currentTrack.duration;
        }

        const pct = Math.min(100, (currentTrack.position / currentTrack.duration) * 100);
        progressBar.style.width = `${pct}%`;
        timeCurrent.textContent = formatTime(currentTrack.position);
        timeTotal.textContent = formatTime(currentTrack.duration);

        updateActiveLyricLine(currentTrack.position * 1000);
      }
    } catch (_) {}
  }

  // Initial media load & tick
  await loadLyrics(currentTrack.title, currentTrack.artist);
  setInterval(syncMedia, 1000);

  // Playback control button listeners
  const playPauseBtns = [
    document.getElementById('hover-play-btn'),
    document.getElementById('expanded-play-btn'),
    document.getElementById('lyrics-play-btn'),
  ];
  playPauseBtns.forEach((btn) => {
    btn.addEventListener('click', async (e) => {
      e.stopPropagation();
      await window.capsuleAPI.controlMedia('playPause');
      currentTrack.isPlaying = !currentTrack.isPlaying;
      btn.textContent = currentTrack.isPlaying ? '⏸' : '▶';
    });
  });

  const nextBtns = [
    document.getElementById('expanded-next-btn'),
    document.getElementById('lyrics-next-btn'),
  ];
  nextBtns.forEach((btn) => {
    btn.addEventListener('click', async (e) => {
      e.stopPropagation();
      await window.capsuleAPI.controlMedia('next');
    });
  });

  const prevBtns = [
    document.getElementById('expanded-prev-btn'),
    document.getElementById('lyrics-prev-btn'),
  ];
  prevBtns.forEach((btn) => {
    btn.addEventListener('click', async (e) => {
      e.stopPropagation();
      await window.capsuleAPI.controlMedia('prev');
    });
  });

  // 5. Volume controls
  const volSliders = [
    document.getElementById('expanded-vol-slider'),
    document.getElementById('system-vol-slider'),
  ];
  volSliders.forEach((slider) => {
    slider.addEventListener('input', (e) => {
      const val = Number(e.target.value);
      volSliders.forEach((s) => (s.value = val));
      window.capsuleAPI.setVolume(val);
    });
  });

  const muteBtns = [
    document.getElementById('expanded-mute-btn'),
    document.getElementById('system-mute-btn'),
  ];
  muteBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      window.capsuleAPI.toggleMute();
    });
  });

  // 6. Weather Service Integration
  async function loadWeather(cityName = 'Kolkata') {
    if (!window.WeatherService) return;
    const weather = await window.WeatherService.fetchWeather(cityName);
    if (!weather) return;

    document.getElementById('idle-weather-icon').textContent = weather.icon;
    document.getElementById('hover-weather-temp').textContent = `${weather.temperature}°C`;
    document.getElementById('weather-temp-display').textContent = `${weather.temperature}°C`;
    document.getElementById('weather-desc-display').textContent = weather.description;
    document.getElementById('weather-city-display').textContent = weather.city;
    document.getElementById('weather-big-icon').textContent = weather.icon;
    document.getElementById('weather-humidity').textContent = weather.humidity;
    document.getElementById('weather-wind').textContent = weather.windSpeed;
    document.getElementById('weather-uv').textContent = weather.uvIndex;

    const forecastGrid = document.getElementById('forecast-grid');
    forecastGrid.innerHTML = '';
    weather.forecast.forEach((f) => {
      const card = document.createElement('div');
      card.className = 'forecast-card';
      card.innerHTML = `
        <span class="forecast-day">${f.day}</span>
        <span class="forecast-icon">${f.icon}</span>
        <span class="forecast-temp">${f.maxTemp}° / ${f.minTemp}°</span>
      `;
      forecastGrid.appendChild(card);
    });
  }
  loadWeather('Kolkata');

  // 7. System Telemetry
  async function updateTelemetry() {
    if (!window.capsuleAPI?.getMetrics) return;
    try {
      const metrics = await window.capsuleAPI.getMetrics();
      if (metrics) {
        document.getElementById('cpu-percent-text').textContent = `${metrics.cpuUsage}%`;
        document.getElementById('cpu-meter-fill').style.width = `${metrics.cpuUsage}%`;

        document.getElementById('ram-percent-text').textContent = `${metrics.ramPercent}%`;
        document.getElementById('ram-meter-fill').style.width = `${metrics.ramPercent}%`;
        document.getElementById('ram-details-text').textContent = `${metrics.ramUsedGb} GB / ${metrics.ramTotalGb} GB used`;

        document.getElementById('system-uptime').textContent = `${metrics.uptimeHours} hours`;
      }
    } catch (_) {}
  }
  updateTelemetry();
  setInterval(updateTelemetry, 2000);

  // 8. Toolbox (Calculator)
  const calcDisplay = document.getElementById('calc-display');
  const calcHistory = document.getElementById('calc-history');
  const calculator = new Calculator(calcDisplay, calcHistory);
  document.querySelectorAll('.calc-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      const action = btn.dataset.op || btn.dataset.num;
      calculator.handleInput(action);
    });
  });

  // 9. Clipboard History Manager
  const clipboardList = document.getElementById('clipboard-list');
  const clearClipBtn = document.getElementById('clear-clipboard-btn');
  new ClipboardManager(clipboardList, clearClipBtn);

  // 10. App Launcher & File Search
  const launcherGrid = document.getElementById('launcher-apps-grid');
  new AppLauncher(launcherGrid);

  const searchInput = document.getElementById('launcher-search-input');
  const resultsBox = document.getElementById('file-results-box');
  const resultsList = document.getElementById('file-results-list');
  new FileSearch(searchInput, resultsBox, resultsList);

  // 11. Settings & Persistence
  if (window.capsuleAPI?.getConfig) {
    try {
      const config = await window.capsuleAPI.getConfig();
      if (config) {
        const topCheckbox = document.getElementById('setting-always-on-top');
        topCheckbox.checked = config.alwaysOnTop ?? true;
        topCheckbox.addEventListener('change', (e) => {
          window.capsuleAPI.setAlwaysOnTop(e.target.checked);
        });

        const cityInput = document.getElementById('setting-city-input');
        cityInput.value = config.weatherCity || 'Kolkata';
        document.getElementById('setting-city-save-btn').addEventListener('click', () => {
          const newCity = cityInput.value.trim();
          if (newCity) {
            window.capsuleAPI.setConfig('weatherCity', newCity);
            loadWeather(newCity);
          }
        });

        const radiusSlider = document.getElementById('setting-corner-radius');
        const radiusLabel = document.getElementById('radius-val-label');
        radiusSlider.value = config.cornerRadius || 19;
        radiusLabel.textContent = `${radiusSlider.value}px`;
        document.documentElement.style.setProperty('--radius-capsule', `${radiusSlider.value}px`);

        radiusSlider.addEventListener('input', (e) => {
          const val = e.target.value;
          radiusLabel.textContent = `${val}px`;
          document.documentElement.style.setProperty('--radius-capsule', `${val}px`);
          window.capsuleAPI.setConfig('cornerRadius', Number(val));
        });
      }
    } catch (_) {}
  }
});
