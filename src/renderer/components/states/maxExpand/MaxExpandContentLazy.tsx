/*
 * Capsule - A sleek, Apple Dynamic Island inspired floating widget for Windows.
 */

/**
 * @file MaxExpandContentLazy.tsx
 * @description MaxExpand 性能模式懒加载内容实现。
 */

import { Suspense, lazy } from 'react';
import type { ReactElement } from 'react';
import type { MaxExpandTab } from '../../../store/types';
import { MaxExpandContentShell } from './MaxExpandContentShell';

const UrlFavoritesTab = lazy(() => import('./components/urlFavorites').then((module) => ({ default: module.UrlFavoritesTab })));
const LocalFileSearchTab = lazy(() => import('./components/localFileSearch/components/LocalFileSearchTab').then((module) => ({ default: module.LocalFileSearchTab })));
const ClipboardHistoryTab = lazy(() => import('./components/clipBoardHistory').then((module) => ({ default: module.ClipboardHistoryTab })));
const AlbumTab = lazy(() => import('./components/album/components/AlbumTab').then((module) => ({ default: module.AlbumTab })));
const SettingsTab = lazy(() => import('./components/setting').then((module) => ({ default: module.SettingsTab })));
const ToolboxTab = lazy(() => import('./components/toolbox').then((module) => ({ default: module.ToolboxTab })));
const CalculatorTab = lazy(() => import('./components/calculator').then((module) => ({ default: module.CalculatorTab })));
const SongTab = lazy(() => import('./components/song'));

function renderLazyActiveTab(activeTab: MaxExpandTab, loadingFallback: ReactElement, contentReady: boolean): ReactElement | null {
  if (!contentReady) return loadingFallback;
  let content: ReactElement | null = null;
  if (activeTab === 'song') content = <SongTab />;
  if (activeTab === 'album') content = <AlbumTab />;
  if (activeTab === 'urlFavorites') content = <UrlFavoritesTab />;
  if (activeTab === 'localFileSearch') content = <LocalFileSearchTab />;
  if (activeTab === 'clipboardHistory') content = <ClipboardHistoryTab />;
  if (activeTab === 'calculator') content = <CalculatorTab />;
  if (activeTab === 'toolbox') content = <ToolboxTab />;
  if (activeTab === 'settings') content = <SettingsTab />;
  return <Suspense fallback={loadingFallback}>{content}</Suspense>;
}

/**
 * 渲染 MaxExpand 的懒加载内容（性能模式）。
 */
export function MaxExpandContentLazy(): ReactElement {
  return <MaxExpandContentShell renderActiveTab={renderLazyActiveTab} performanceModeEnabled />;
}
