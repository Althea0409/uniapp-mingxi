<template>
  <button 
    :class="['custom-button', `button-${type}`, `button-${size}`, { 'button-loading': loading, 'button-disabled': disabled }]"
    :disabled="disabled || loading"
    :hover-class="disabled || loading ? '' : 'button-hover'"
    @tap="handleClick"
  >
    <view v-if="loading" class="loading-icon"></view>
    <text v-if="!loading || showTextWhenLoading">{{ text }}</text>
    <slot v-if="!text"></slot>
  </button>
</template>

<script setup lang="ts">
interface Props {
  // 按钮类型
  type?: 'primary' | 'secondary' | 'text';
  // 按钮大小
  size?: 'default' | 'small' | 'large';
  // 按钮文字
  text?: string;
  // 是否禁用
  disabled?: boolean;
  // 是否加载中
  loading?: boolean;
  // 加载中时是否显示文字
  showTextWhenLoading?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  type: 'primary',
  size: 'default',
  text: '',
  disabled: false,
  loading: false,
  showTextWhenLoading: true,
});

const emit = defineEmits<{
  click: [];
}>();

// 处理点击事件
const handleClick = () => {
  if (!props.disabled && !props.loading) {
    emit('click');
  }
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.custom-button {
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  outline: none;
  font-size: $font-size-base;
  font-weight: bold;
  transition: $transition-fast;
  position: relative;
  overflow: hidden;
  
  &::after {
    border: none;
  }
}

// 按钮类型
.button-primary {
  background: $gradient-primary;
  color: $text-white;
  height: $button-height;
  border-radius: $border-radius-round;
  box-shadow: $shadow-button;
}

.button-secondary {
  background-color: $card-bg;
  color: $primary-color;
  height: $button-height;
  border-radius: $border-radius-round;
  border: 2rpx solid $primary-color;
}

.button-text {
  background-color: transparent;
  color: $primary-color;
  height: auto;
  padding: $padding-xs $padding-sm;
}

// 按钮大小
.button-small {
  height: $button-height-small;
  font-size: $font-size-sm;
  padding: 0 32rpx;
}

.button-default {
  padding: 0 48rpx;
}

.button-large {
  width: 100%;
  padding: 0 64rpx;
}

// 按钮状态
.button-hover {
  opacity: 0.8;
  transform: scale(0.98);
}

.button-disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.button-loading {
  opacity: 0.8;
}

// 加载图标
.loading-icon {
  width: 32rpx;
  height: 32rpx;
  border: 4rpx solid rgba(255, 255, 255, 0.3);
  border-top-color: $text-white;
  border-radius: 50%;
  animation: rotate 0.8s linear infinite;
  margin-right: 8rpx;
}

.button-secondary .loading-icon,
.button-text .loading-icon {
  border: 4rpx solid rgba(43, 70, 254, 0.3);
  border-top-color: $primary-color;
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>

