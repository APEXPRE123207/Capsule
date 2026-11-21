/*
 * Capsule - A sleek, Apple Dynamic Island inspired floating widget for Windows.
 */

/**
 * @file MaxExpandContentEager.tsx
 * @description MaxExpand 非性能模式（一次性加载）内容实现。
 */

import type { ReactElement } from 'react';
import type { MaxExpandTab } from '../../../store/types';
import { MaxExpandContentShell } from './MaxExpandContentShell';
import { UrlFavoritesTab } from './components/urlFavorites';
import { LocalFileSearchTab } from './components/localFileSearch/components/LocalFileSearchTab';
import { ClipboardHistoryTab } from './components/clipBoardHistory';
import { AlbumTab } from './components/album/components/AlbumTab';
import { SettingsTab } from './components/setting';
import { ToolboxTab } from './components/toolbox';
import { CalculatorTab } from './components/calculator';
import SongTab from './components/song';

function renderEagerActiveTab(activeTab: MaxExpandTab, loadingFallback: ReactElement, contentReady: boolean): ReactElement | null {
  if (!contentReady) return loadingFallback;
  if (activeTab === 'song') return <SongTab />;
  if (activeTab === 'album') return <AlbumTab />;
  if (activeTab === 'urlFavorites') return <UrlFavoritesTab />;
  if (activeTab === 'localFileSearch') return <LocalFileSearchTab />;
  if (activeTab === 'clipboardHistory') return <ClipboardHistoryTab />;
  if (activeTab === 'calculator') return <CalculatorTab />;
  if (activeTab === 'toolbox') return <ToolboxTab />;
  if (activeTab === 'settings') return <SettingsTab />;
  return null;
}

/**
 * 渲染 MaxExpand 的一次性加载内容。
 */
export function MaxExpandContentEager(): ReactElement {
  return <MaxExpandContentShell renderActiveTab={renderEagerActiveTab} deferContent={false} />;
}
