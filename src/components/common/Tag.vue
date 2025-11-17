<template>
  <view :class="['tag', `tag-${type}`, `tag-${size}`]" @tap="handleClick">
    <text class="tag-text">{{ text }}</text>
    <slot></slot>
  </view>
</template>

<script setup lang="ts">
interface Props {
  // 标签文字
  text?: string;
  // 标签类型
  type?: 'primary' | 'success' | 'warning' | 'error' | 'info';
  // 标签大小
  size?: 'small' | 'default' | 'large';
}

const props = withDefaults(defineProps<Props>(), {
  text: '',
  type: 'primary',
  size: 'default',
});

const emit = defineEmits<{
  click: [];
}>();

// 处理点击事件
const handleClick = () => {
  emit('click');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: $border-radius-small;
  font-size: $font-size-xs;
  transition: $transition-fast;
}

// 标签类型
.tag-primary {
  background-color: rgba(43, 70, 254, 0.1);
  color: $primary-color;
}

.tag-success {
  background-color: rgba(82, 196, 26, 0.1);
  color: $success-color;
}

.tag-warning {
  background-color: rgba(250, 173, 20, 0.1);
  color: $warning-color;
}

.tag-error {
  background-color: rgba(245, 34, 45, 0.1);
  color: $error-color;
}

.tag-info {
  background-color: rgba(24, 144, 255, 0.1);
  color: $info-color;
}

// 标签大小
.tag-small {
  padding: 4rpx 12rpx;
  font-size: $font-size-xs;
}

.tag-default {
  padding: 8rpx 16rpx;
  font-size: $font-size-xs;
}

.tag-large {
  padding: 12rpx 20rpx;
  font-size: $font-size-sm;
}

.tag-text {
  line-height: 1;
}
</style>

