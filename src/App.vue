<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
import { useUserStore } from '@/stores/user';
import { useAppStore } from '@/stores/app';
import PopupEncourage from '@/components/common/PopupEncourage.vue';

onLaunch(() => {
  console.log("App Launch");
  
  // 初始化路由守卫
  initRouteGuard();
});

onShow(() => {
  console.log("App Show");
});

onHide(() => {
  console.log("App Hide");
});

/**
 * 初始化路由守卫
 * 检查登录状态，未登录则跳转到登录页
 */
const initRouteGuard = () => {
  const userStore = useUserStore();
  const appStore = useAppStore();
  
  // 获取当前页面栈
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1];
  const currentRoute = currentPage ? `/${currentPage.route}` : '';
  
  // 白名单：不需要登录即可访问的页面
  const whiteList = ['/pages/auth/login', '/pages/auth/register'];
  
  // 如果未登录且不在白名单中，跳转到登录页
  if (!userStore.isLogin && !whiteList.includes(currentRoute)) {
    console.log('用户未登录，跳转到登录页');
    // 延迟跳转，确保应用初始化完成
    setTimeout(() => {
      uni.reLaunch({
        url: '/pages/auth/login',
      });
    }, 100);
  } else if (userStore.isLogin) {
    console.log('用户已登录:', userStore.userName);
    // 加载激励语
    appStore.getRandomEncouragement();
  }
};
</script>
<style lang="scss">
@import './styles/common.scss';
</style>
<template>
  <PopupEncourage 
    :visible="useAppStore().encourageVisible" 
    :type="useAppStore().encourageType" 
    :text="useAppStore().encouragement" 
    @close="useAppStore().closeEncouragement()" />
</template>
