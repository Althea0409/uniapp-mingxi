// 课程Store
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { Course, Homework, Preview, ScheduleItem } from '@/types/course';
import { storage, StorageKeys } from '@/utils/storage';

export const useCourseStore = defineStore('course', () => {
  // 状态
  const courseList = ref<Course[]>(storage.get(StorageKeys.COURSES) || []);
  const homeworkList = ref<Homework[]>(storage.get(StorageKeys.HOMEWORK) || []);
  const previewList = ref<Preview[]>(storage.get(StorageKeys.PREVIEW) || []);
  const scheduleList = ref<ScheduleItem[]>(storage.get(StorageKeys.SCHEDULE) || []);
  
  // 计算属性
  const ongoingCourses = computed(() => 
    courseList.value.filter(c => c.status === 'ongoing')
  );
  
  const completedCourses = computed(() => 
    courseList.value.filter(c => c.status === 'completed')
  );
  
  const pendingHomework = computed(() => 
    homeworkList.value.filter(h => h.status === 'pending')
  );
  
  const submittedHomework = computed(() => 
    homeworkList.value.filter(h => h.status === 'submitted' || h.status === 'graded')
  );
  
  const uncompletedPreview = computed(() => 
    previewList.value.filter(p => !p.completed)
  );
  
  // 方法
  /**
   * 获取课程列表
   */
  async function getCourseList() {
    try {
      // Mock数据
      // 实际项目中这里应该调用API
      const mockCourses: Course[] = [
        {
          id: 'c001',
          name: '高等数学（上）',
          teacher: '张教授',
          department: '数学学院',
          cover: '/static/course/math.svg',
          progress: 78,
          chapter: '第8章',
          nextClass: '本周3节课',
          status: 'ongoing',
        },
        {
          id: 'c002',
          name: '大学英语（二）',
          teacher: 'Lisa老师',
          department: '外语学院',
          cover: '/static/course/english.svg',
          progress: 45,
          chapter: 'Unit 5',
          nextClass: '明天10:00',
          status: 'ongoing',
        },
        {
          id: 'c003',
          name: '计算机导论',
          teacher: '王老师',
          department: '计算机学院',
          cover: '/static/course/science.svg',
          progress: 100,
          chapter: '已完成',
          nextClass: '',
          status: 'completed',
        },
      ];
      
      courseList.value = mockCourses;
      storage.set(StorageKeys.COURSES, mockCourses);
      
      return mockCourses;
    } catch (error) {
      console.error('获取课程列表失败:', error);
      return [];
    }
  }
  
  /**
   * 获取作业列表
   */
  async function getHomeworkList() {
    try {
      // Mock数据
      const mockHomework: Homework[] = [
        {
          id: 'h001',
          courseId: 'c001',
          courseName: '数学分析',
          title: '第3章习题',
          deadline: '2025-11-20 23:59',
          description: '完成第3章所有习题',
          questionTypes: '选择题5道 + 解答题3道',
          status: 'pending',
        },
        {
          id: 'h002',
          courseId: 'c002',
          courseName: '英语',
          title: 'Unit 5 练习',
          deadline: '2025-11-22 23:59',
          description: '完成Unit 5的所有练习题',
          questionTypes: '阅读理解2篇 + 写作1篇',
          status: 'pending',
        },
        {
          id: 'h003',
          courseId: 'c002',
          courseName: '英语',
          title: 'Unit 4 练习',
          deadline: '',
          description: '',
          questionTypes: '',
          status: 'graded',
          submitTime: '2025-11-15 18:30',
          score: 92,
          totalScore: 100,
          timeSpent: 28,
          teacherComment: '完成质量很好！',
        },
      ];
      
      homeworkList.value = mockHomework;
      storage.set(StorageKeys.HOMEWORK, mockHomework);
      
      return mockHomework;
    } catch (error) {
      console.error('获取作业列表失败:', error);
      return [];
    }
  }
  
  /**
   * 获取预习列表
   */
  async function getPreviewList() {
    try {
      // Mock数据
      const mockPreview: Preview[] = [
        {
          id: 'p001',
          courseId: 'c001',
          courseName: '物理',
          title: '第7章 电磁感应',
          duration: 30,
          publishTime: '今天 08:00',
          content: ['观看视频讲解（15分钟）', '阅读教材P125-P138', '完成思考题3道'],
          completed: false,
        },
        {
          id: 'p002',
          courseId: 'c002',
          courseName: '数学',
          title: '第9章 微积分',
          duration: 45,
          publishTime: '昨天 20:00',
          content: ['阅读教材P200-P215', '完成课前练习题', '预习微积分基本概念'],
          completed: true,
        },
      ];
      
      previewList.value = mockPreview;
      storage.set(StorageKeys.PREVIEW, mockPreview);
      
      return mockPreview;
    } catch (error) {
      console.error('获取预习列表失败:', error);
      return [];
    }
  }
  
  /**
   * 获取课表
   */
  async function getSchedule() {
    try {
      // Mock数据
      const mockSchedule: ScheduleItem[] = [
        {
          id: 's001',
          courseId: 'c001',
          courseName: '高等数学',
          teacher: '张教授',
          location: '教学楼A-201',
          startTime: '08:00',
          endTime: '09:40',
          weekday: 1,
          week: 10,
        },
        {
          id: 's002',
          courseId: 'c002',
          courseName: '大学英语',
          teacher: 'Lisa老师',
          location: '外语楼B-305',
          startTime: '10:00',
          endTime: '11:40',
          weekday: 1,
          week: 10,
        },
      ];
      
      scheduleList.value = mockSchedule;
      storage.set(StorageKeys.SCHEDULE, mockSchedule);
      
      return mockSchedule;
    } catch (error) {
      console.error('获取课表失败:', error);
      return [];
    }
  }
  
  /**
   * 更新课程进度
   * @param courseId 课程ID
   * @param progress 进度
   */
  function updateCourseProgress(courseId: string, progress: number) {
    const course = courseList.value.find(c => c.id === courseId);
    if (course) {
      course.progress = progress;
      storage.set(StorageKeys.COURSES, courseList.value);
    }
  }
  
  /**
   * 提交作业
   * @param homeworkId 作业ID
   */
  function submitHomework(homeworkId: string) {
    const homework = homeworkList.value.find(h => h.id === homeworkId);
    if (homework) {
      homework.status = 'submitted';
      homework.submitTime = new Date().toLocaleString();
      storage.set(StorageKeys.HOMEWORK, homeworkList.value);
    }
  }
  
  /**
   * 完成预习
   * @param previewId 预习ID
   */
  function completePreview(previewId: string) {
    const preview = previewList.value.find(p => p.id === previewId);
    if (preview) {
      preview.completed = true;
      storage.set(StorageKeys.PREVIEW, previewList.value);
    }
  }
  
  return {
    // 状态
    courseList,
    homeworkList,
    previewList,
    scheduleList,
    // 计算属性
    ongoingCourses,
    completedCourses,
    pendingHomework,
    submittedHomework,
    uncompletedPreview,
    // 方法
    getCourseList,
    getHomeworkList,
    getPreviewList,
    getSchedule,
    updateCourseProgress,
    submitHomework,
    completePreview,
  };
});

