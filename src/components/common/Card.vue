<template>
  <view :class="['card', customClass]" :style="cardStyle" @tap="handleClick">
    <slot></slot>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  // 内边距
  padding?: string;
  // 外边距
  margin?: string;
  // 圆角
  radius?: string;
  // 是否显示阴影
  shadow?: boolean;
  // 背景色
  background?: string;
  // 自定义类名
  customClass?: string;
}

const props = withDefaults(defineProps<Props>(), {
  padding: '24rpx',
  margin: '0 0 24rpx 0',
  radius: '16rpx',
  shadow: true,
  background: '#FFFFFF',
  customClass: '',
});

const emit = defineEmits<{
  click: [];
}>();

// 计算卡片样式
const cardStyle = computed(() => {
  return {
    padding: props.padding,
    margin: props.margin,
    borderRadius: props.radius,
    backgroundColor: props.background,
    boxShadow: props.shadow ? '0 4rpx 12rpx rgba(0, 0, 0, 0.05)' : 'none',
  };
});

// 处理点击事件
const handleClick = () => {
  emit('click');
};
</script>

<style lang="scss" scoped>
.card {
  background-color: #FFFFFF;
  overflow: hidden;
  transition: all 0.3s ease;
}
</style>

