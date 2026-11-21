/*
 * Capsule - A sleek, Apple Dynamic Island inspired floating widget for Windows.
 */

/**
 * @file standaloneWindowTabs.ts
 * @description 独立窗口标签页配置。
 */

import type { WindowTab } from './standaloneWindowTypes';

export const VALID_TABS = new Set<WindowTab>(['urlFavorites', 'album', 'localFileSearch', 'clipboardHistory', 'toolbox', 'settings']);

export const TAB_LIST: { key: WindowTab; labelKey: string }[] = [
  { key: 'urlFavorites', labelKey: 'standalone.tabs.urlFavorites' },
  { key: 'album', labelKey: 'standalone.tabs.album' },
  { key: 'localFileSearch', labelKey: 'standalone.tabs.localFileSearch' },
  { key: 'clipboardHistory', labelKey: 'standalone.tabs.clipboardHistory' },
  { key: 'toolbox', labelKey: 'standalone.tabs.toolbox' },
  { key: 'settings', labelKey: 'standalone.tabs.settings' },
];
