// Open-Meteo Weather Service
const WeatherService = {
  wmoCodeMap: {
    0: { desc: 'Clear sky', icon: '☀️' },
    1: { desc: 'Mainly clear', icon: '🌤' },
    2: { desc: 'Partly cloudy', icon: '⛅' },
    3: { desc: 'Overcast', icon: '☁️' },
    45: { desc: 'Fog', icon: '🌫' },
    48: { desc: 'Depositing rime fog', icon: '🌫' },
    51: { desc: 'Light drizzle', icon: '🌦' },
    53: { desc: 'Moderate drizzle', icon: '🌦' },
    55: { desc: 'Dense drizzle', icon: '🌧' },
    61: { desc: 'Slight rain', icon: '🌧' },
    63: { desc: 'Moderate rain', icon: '🌧' },
    65: { desc: 'Heavy rain', icon: '⛈' },
    71: { desc: 'Slight snow', icon: '🌨' },
    73: { desc: 'Moderate snow', icon: '🌨' },
    75: { desc: 'Heavy snow', icon: '❄️' },
    80: { desc: 'Rain showers', icon: '🌦' },
    82: { desc: 'Violent rain showers', icon: '⛈' },
    95: { desc: 'Thunderstorm', icon: '⚡' },
  },

  async geocodeCity(cityName) {
    try {
      const url = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(cityName)}&count=1&language=en&format=json`;
      const res = await fetch(url);
      if (!res.ok) return null;
      const data = await res.json();
      if (data.results && data.results.length > 0) {
        return {
          name: data.results[0].name,
          lat: data.results[0].latitude,
          lon: data.results[0].longitude,
        };
      }
    } catch (_) {}
    // Default fallback to Kolkata
    return { name: 'Kolkata', lat: 22.5726, lon: 88.3639 };
  },

  async fetchWeather(cityName = 'Kolkata') {
    const loc = await this.geocodeCity(cityName);
    if (!loc) return null;

    try {
      const url = `https://api.open-meteo.com/v1/forecast?latitude=${loc.lat}&longitude=${loc.lon}&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max&timezone=auto&forecast_days=3`;
      const res = await fetch(url);
      if (!res.ok) throw new Error('Weather fetch failed');
      const data = await res.json();

      const currentCode = data.current?.weather_code ?? 0;
      const currentMapping = this.wmoCodeMap[currentCode] || { desc: 'Clear', icon: '☀️' };

      const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      const forecast = [];

      if (data.daily && data.daily.time) {
        for (let i = 0; i < data.daily.time.length; i++) {
          const d = new Date(data.daily.time[i]);
          const dayName = i === 0 ? 'Today' : daysOfWeek[d.getDay()];
          const code = data.daily.weather_code[i] ?? 0;
          const map = this.wmoCodeMap[code] || { icon: '☀️' };
          forecast.push({
            day: dayName,
            icon: map.icon,
            maxTemp: Math.round(data.daily.temperature_2m_max[i] ?? 28),
            minTemp: Math.round(data.daily.temperature_2m_min[i] ?? 20),
          });
        }
      }

      return {
        city: loc.name,
        temperature: Math.round(data.current?.temperature_2m ?? 26),
        description: currentMapping.desc,
        icon: currentMapping.icon,
        humidity: `${Math.round(data.current?.relative_humidity_2m ?? 60)}%`,
        windSpeed: `${Math.round(data.current?.wind_speed_10m ?? 12)} km/h`,
        uvIndex: `${Math.round(data.daily?.uv_index_max?.[0] ?? 4)} (Moderate)`,
        forecast,
      };
    } catch (_) {
      // Offline fallback
      return {
        city: loc.name,
        temperature: 26,
        description: 'Clear sky',
        icon: '☀️',
        humidity: '65%',
        windSpeed: '12 km/h',
        uvIndex: '4 (Moderate)',
        forecast: [
          { day: 'Today', icon: '☀️', maxTemp: 29, minTemp: 21 },
          { day: 'Tomorrow', icon: '⛅', maxTemp: 28, minTemp: 20 },
          { day: 'Day After', icon: '🌦', maxTemp: 27, minTemp: 19 },
        ],
      };
    }
  },
};

window.WeatherService = WeatherService;
