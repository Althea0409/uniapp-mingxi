// 表单验证工具

/**
 * 验证手机号
 * @param phone 手机号
 * @returns 是否有效
 */
export function validatePhone(phone: string): boolean {
  const reg = /^1[3-9]\d{9}$/;
  return reg.test(phone);
}

/**
 * 验证密码（8-16位，必须包含字母和数字）
 * @param password 密码
 * @returns 是否有效
 */
export function validatePassword(password: string): boolean {
  const reg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$/;
  return reg.test(password);
}

/**
 * 验证验证码（6位数字）
 * @param code 验证码
 * @returns 是否有效
 */
export function validateCode(code: string): boolean {
  const reg = /^\d{6}$/;
  return reg.test(code);
}

/**
 * 验证姓名（2-10个字符，中文、英文、数字）
 * @param name 姓名
 * @returns 是否有效
 */
export function validateName(name: string): boolean {
  const reg = /^[\u4e00-\u9fa5a-zA-Z0-9]{2,10}$/;
  return reg.test(name);
}

/**
 * 验证邮箱
 * @param email 邮箱
 * @returns 是否有效
 */
export function validateEmail(email: string): boolean {
  const reg = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
  return reg.test(email);
}

/**
 * 验证是否为空
 * @param value 值
 * @returns 是否为空
 */
export function isEmpty(value: any): boolean {
  if (value === null || value === undefined || value === '') {
    return true;
  }
  if (typeof value === 'string' && value.trim() === '') {
    return true;
  }
  if (Array.isArray(value) && value.length === 0) {
    return true;
  }
  return false;
}

/**
 * 获取密码强度
 * @param password 密码
 * @returns weak | medium | strong
 */
export function getPasswordStrength(password: string): 'weak' | 'medium' | 'strong' {
  if (password.length < 8) {
    return 'weak';
  }
  
  let strength = 0;
  // 包含小写字母
  if (/[a-z]/.test(password)) strength++;
  // 包含大写字母
  if (/[A-Z]/.test(password)) strength++;
  // 包含数字
  if (/\d/.test(password)) strength++;
  // 包含特殊字符
  if (/[^a-zA-Z0-9]/.test(password)) strength++;
  
  if (strength <= 2) return 'weak';
  if (strength === 3) return 'medium';
  return 'strong';
}

/**
 * 表单验证规则类
 */
export class FormValidator {
  private rules: Record<string, any[]>;
  private errors: Record<string, string>;

  constructor() {
    this.rules = {};
    this.errors = {};
  }

  /**
   * 添加验证规则
   * @param field 字段名
   * @param rules 规则数组
   */
  addRule(field: string, rules: any[]): void {
    this.rules[field] = rules;
  }

  /**
   * 验证单个字段
   * @param field 字段名
   * @param value 字段值
   * @returns 是否通过验证
   */
  validateField(field: string, value: any): boolean {
    const rules = this.rules[field];
    if (!rules) return true;

    for (const rule of rules) {
      if (rule.required && isEmpty(value)) {
        this.errors[field] = rule.message || '此项为必填项';
        return false;
      }

      if (rule.validator && typeof rule.validator === 'function') {
        const result = rule.validator(value);
        if (!result) {
          this.errors[field] = rule.message || '验证失败';
          return false;
        }
      }

      if (rule.pattern && !rule.pattern.test(value)) {
        this.errors[field] = rule.message || '格式不正确';
        return false;
      }

      if (rule.min !== undefined && value.length < rule.min) {
        this.errors[field] = rule.message || `最少${rule.min}个字符`;
        return false;
      }

      if (rule.max !== undefined && value.length > rule.max) {
        this.errors[field] = rule.message || `最多${rule.max}个字符`;
        return false;
      }
    }

    delete this.errors[field];
    return true;
  }

  /**
   * 验证所有字段
   * @param data 表单数据
   * @returns 是否通过验证
   */
  validate(data: Record<string, any>): boolean {
    this.errors = {};
    let isValid = true;

    for (const field in this.rules) {
      const value = data[field];
      if (!this.validateField(field, value)) {
        isValid = false;
      }
    }

    return isValid;
  }

  /**
   * 获取错误信息
   * @param field 字段名，不传则返回所有错误
   * @returns 错误信息
   */
  getError(field?: string): string | Record<string, string> {
    if (field) {
      return this.errors[field] || '';
    }
    return this.errors;
  }

  /**
   * 清空错误信息
   */
  clearErrors(): void {
    this.errors = {};
  }
}

/**
 * 常用验证规则
 */
export const Rules = {
  phone: [
    { required: true, message: '请输入手机号' },
    { validator: validatePhone, message: '手机号格式不正确' },
  ],
  password: [
    { required: true, message: '请输入密码' },
    { validator: validatePassword, message: '密码必须为8-16位，包含字母和数字' },
  ],
  code: [
    { required: true, message: '请输入验证码' },
    { validator: validateCode, message: '验证码格式不正确' },
  ],
  name: [
    { required: true, message: '请输入姓名' },
    { validator: validateName, message: '姓名格式不正确' },
  ],
  email: [
    { required: true, message: '请输入邮箱' },
    { validator: validateEmail, message: '邮箱格式不正确' },
  ],
};

