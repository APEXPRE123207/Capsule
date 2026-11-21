/*
 * Capsule - A sleek, Apple Dynamic Island inspired floating widget for Windows.
 */

/**
 * @file StandaloneWindowViewport.tsx
 * @description 独立窗口内容视口组件。
 */

import { lazy, Suspense, type ComponentType, type JSX, type LazyExoticComponent } from 'react';
import { useTranslation } from 'react-i18next';
import type { WindowTab } from '../config/standaloneWindowConfig';

const UrlFavoritesTab = lazy(() => import('../states/maxExpand/components/urlFavorites').then((module) => ({ default: module.UrlFavoritesTab })));
const AlbumTab = lazy(() => import('../states/maxExpand/components/album/components/AlbumTab').then((module) => ({ default: module.AlbumTab })));
const LocalFileSearchTab = lazy(() => import('../states/maxExpand/components/localFileSearch/components/LocalFileSearchTab').then((module) => ({ default: module.LocalFileSearchTab })));
const ClipboardHistoryTab = lazy(() => import('../states/maxExpand/components/clipBoardHistory').then((module) => ({ default: module.ClipboardHistoryTab })));
const SettingsTab = lazy(() => import('../states/maxExpand/components/setting').then((module) => ({ default: module.SettingsTab })));
const ToolboxTab = lazy(() => import('../states/maxExpand/components/toolbox').then((module) => ({ default: module.ToolboxTab })));
const LoginContent = lazy(() => import('../states/login').then((module) => ({ default: module.LoginContent })));
const RegisterContent = lazy(() => import('../states/register/RegisterContent').then((module) => ({ default: module.RegisterContent })));
const ResetPasswordContent = lazy(() => import('../states/resetPassword').then((module) => ({ default: module.ResetPasswordContent })));
const PaymentContent = lazy(() => import('../states/payment/PaymentContent').then((module) => ({ default: module.PaymentContent })));
const MusicProvidersLoginContent = lazy(() => import('../states/musicProvidersLogin').then((module) => ({ default: module.MusicProvidersLoginContent })));
const FileTransferContent = lazy(() => import('../states/fileTransfer').then((module) => ({ default: module.FileTransferContent })));

type LazyPage = LazyExoticComponent<ComponentType>;

/** 普通标签页与页面组件的映射；settings 由 resolvePage 单独处理 */
const TAB_PAGES: Record<Exclude<WindowTab, 'settings'>, LazyPage> = {
  urlFavorites: UrlFavoritesTab,
  album: AlbumTab,
  localFileSearch: LocalFileSearchTab,
  clipboardHistory: ClipboardHistoryTab,
  toolbox: ToolboxTab,
};

/** settings 标签页下需替换 SettingsTab 的岛屿状态页面 */
const SETTINGS_STATE_PAGES: Partial<Record<string, LazyPage>> = {
  login: LoginContent,
  register: RegisterContent,
  resetPassword: ResetPasswordContent,
  payment: PaymentContent,
  musicProvidersLogin: MusicProvidersLoginContent,
  fileTransfer: FileTransferContent,
};

/**
 * 解析当前标签页与岛屿状态对应的页面组件。
 */
function resolvePage(activeTab: WindowTab, state: string): LazyPage {
  if (activeTab === 'settings') return SETTINGS_STATE_PAGES[state] ?? SettingsTab;
  return TAB_PAGES[activeTab] ?? SettingsTab;
}

interface StandaloneWindowViewportProps {
  activeTab: WindowTab;
  state: string;
}

/**
 * 根据标签页渲染独立窗口内容。
 */
export function StandaloneWindowViewport({ activeTab, state }: StandaloneWindowViewportProps): JSX.Element {
  const { t } = useTranslation();
  const Page = resolvePage(activeTab, state);
  return (
    <div className="cw-viewport">
      <Suspense fallback={<div className="cw-viewport-loading">{t('standalone.loading', 'Loading...')}</div>}>
        <Page />
      </Suspense>
    </div>
  );
}
