// 用户相关类型定义

// 用户信息
export interface UserInfo {
  id: string;
  phone: string;
  name: string;
  avatar: string;
  level: number;
  exp: number;
  points: number;
  badges: number;
  school: string;
  grade: string;
  class: string;
}

// 登录表单
export interface LoginForm {
  phone: string;
  password: string;
  remember?: boolean;
}

// 注册表单
export interface RegisterForm {
  name: string;
  phone: string;
  code: string;
  password: string;
  confirmPassword: string;
  school: string;
  grade: string;
  class: string;
  agree: boolean;
}

// 成就
export interface Achievement {
  id: string;
  name: string;
  icon: string;
  description: string;
  status: 'unlocked' | 'in-progress' | 'locked';
  progress?: number;
  total?: number;
  reward: number;
  unlockTime?: string;
}

