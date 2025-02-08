// Import and register all your controllers from the importmap under controllers/*

import ThemeController from './theme_controller';
import ChartController from './chart_controller';

export function registerControllers(application) {
  application.register('theme', ThemeController);
  application.register('chart', ChartController);
}
