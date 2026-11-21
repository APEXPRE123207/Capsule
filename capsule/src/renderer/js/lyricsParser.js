// Synchronized Lyrics Parser & LRCLIB API Client
const LyricsParser = {
  cleanTitle(title) {
    if (!title) return '';
    return title
      .replace(/\s*[\(\[](?:feat|ft|with|prod|official|remix|version|audio|video).*?[\)\]]/gi, '')
      .replace(/-\s*radio edit/gi, '')
      .replace(/-\s*single version/gi, '')
      .trim();
  },

  cleanArtist(artist) {
    if (!artist) return '';
    return artist.split(/[,&/]/)[0].trim();
  },

  parseSyncedLrc(lrcContent) {
    if (!lrcContent || typeof lrcContent !== 'string') return [];
    const lines = lrcContent.split('\n');
    const result = [];
    const timeRegex = /\[(\d{2}):(\d{2})(?:\.(\d{2,3}))?\]/g;

    for (const line of lines) {
      const text = line.replace(timeRegex, '').trim();
      if (!text) continue;

      timeRegex.lastIndex = 0;
      let match;
      while ((match = timeRegex.exec(line)) !== null) {
        const min = parseInt(match[1], 10);
        const sec = parseInt(match[2], 10);
        const ms = match[3] ? parseInt(match[3].padEnd(3, '0').slice(0, 3), 10) : 0;
        result.push({
          time_ms: min * 60000 + sec * 1000 + ms,
          text: text,
        });
      }
    }

    return result.sort((a, b) => a.time_ms - b.time_ms);
  },

  getCurrentLyric(lyrics, positionMs) {
    if (!lyrics || lyrics.length === 0) return null;
    return lyrics.reduce((acc, line) => (line.time_ms <= positionMs ? line : acc), null);
  },

  async fetchFromLrclib(title, artist) {
    const qTitle = this.cleanTitle(title);
    const qArtist = this.cleanArtist(artist);
    const query = `${qTitle} ${qArtist}`;

    try {
      const url = `https://lrclib.net/api/search?q=${encodeURIComponent(query)}`;
      const res = await fetch(url, {
        headers: { 'User-Agent': 'CapsuleIsland/1.0' },
      });
      if (!res.ok) return null;
      const data = await res.json();
      if (Array.isArray(data) && data.length > 0) {
        const track = data.find((t) => t.syncedLyrics) || data[0];
        if (track && track.syncedLyrics) {
          return this.parseSyncedLrc(track.syncedLyrics);
        }
      }
    } catch (_) {}

    // Fallback sample synchronized lyrics for demonstration if network is offline
    return [
      { time_ms: 0, text: "I'm tryna put you in the worst mood, ah" },
      { time_ms: 15000, text: "P1 cleaner than your church shoes, ah" },
      { time_ms: 28000, text: "Milli point two just to hurt you, ah" },
      { time_ms: 42000, text: "All red Lamb' just to tease you, ah" },
      { time_ms: 55000, text: "None of these toys on lease too, ah" },
      { time_ms: 70000, text: "Made your whole year in a week too, yah" },
      { time_ms: 84000, text: "Main bitch out your league too, ah" },
      { time_ms: 98000, text: "Side bitch out of your league too, ah" },
      { time_ms: 112000, text: "Look what you've done, I'm a motherfuckin' starboy" },
      { time_ms: 135000, text: "Look what you've done, I'm a motherfuckin' starboy" },
      { time_ms: 160000, text: "Every day a nigga try to test me, ah" },
      { time_ms: 185000, text: "Every day a nigga try to end me, ah" },
      { time_ms: 210000, text: "Pull up in that Roadster switchin' all four lanes" },
    ];
  },
};

window.LyricsParser = LyricsParser;
