/*
Navicat MySQL Data Transfer

Source Server         : shop
Source Server Version : 50722
Source Host           : localhost:3306
Source Database       : evaluation

Target Server Type    : MYSQL
Target Server Version : 50722
File Encoding         : 65001

Date: 2025-11-20 19:24:38
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for audio_history
-- ----------------------------
DROP TABLE IF EXISTS `audio_history`;
CREATE TABLE `audio_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `text` text,
  `audio_url` varchar(500) NOT NULL,
  `duration_seconds` int(11) DEFAULT NULL,
  `source` varchar(50) DEFAULT 'bailian',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audio_user_id` (`user_id`),
  KEY `idx_audio_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of audio_history
-- ----------------------------

-- ----------------------------
-- Table structure for chat_history
-- ----------------------------
DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `prompt` text,
  `response` longtext,
  `model` varchar(100) DEFAULT NULL,
  `source` varchar(50) DEFAULT 'bailian',
  `usage_snapshot` text,
  `request_id` varchar(100) DEFAULT NULL,
  `lesson_plan_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_lesson_plan_id` (`lesson_plan_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`lesson_plan_id`) REFERENCES `lesson_plan` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of chat_history
-- ----------------------------

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `invite_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `class_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of class
-- ----------------------------
INSERT INTO `class` VALUES ('1', '1', '七年级语文1班', 'ABC123');
INSERT INTO `class` VALUES ('2', '1', '七年级语文2班', 'DEF456');
INSERT INTO `class` VALUES ('3', '2', '七年级数学1班', 'GHI789');
INSERT INTO `class` VALUES ('4', '3', '八年级英语1班', 'JKL012');

-- ----------------------------
-- Table structure for class_interaction
-- ----------------------------
DROP TABLE IF EXISTS `class_interaction`;
CREATE TABLE `class_interaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `lesson_date` date DEFAULT NULL,
  `understand_level` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `class_interaction_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of class_interaction
-- ----------------------------
INSERT INTO `class_interaction` VALUES ('1', '1', '2025-11-20', '4', '2025-11-20');
INSERT INTO `class_interaction` VALUES ('2', '1', '2025-11-19', '5', '2025-11-19');
INSERT INTO `class_interaction` VALUES ('3', '1', '2025-11-18', '4', '2025-11-18');
INSERT INTO `class_interaction` VALUES ('4', '1', '2025-11-17', '3', '2025-11-17');
INSERT INTO `class_interaction` VALUES ('5', '1', '2025-11-16', '4', '2025-11-16');
INSERT INTO `class_interaction` VALUES ('6', '1', '2025-11-15', '5', '2025-11-15');
INSERT INTO `class_interaction` VALUES ('7', '1', '2025-11-14', '4', '2025-11-14');
INSERT INTO `class_interaction` VALUES ('8', '2', '2025-11-20', '5', '2025-11-20');
INSERT INTO `class_interaction` VALUES ('9', '2', '2025-11-19', '4', '2025-11-19');
INSERT INTO `class_interaction` VALUES ('10', '2', '2025-11-18', '5', '2025-11-18');
INSERT INTO `class_interaction` VALUES ('11', '1', '2025-11-13', '4', '2025-11-13');
INSERT INTO `class_interaction` VALUES ('12', '1', '2025-11-12', '4', '2025-11-12');
INSERT INTO `class_interaction` VALUES ('13', '1', '2025-11-11', '5', '2025-11-11');
INSERT INTO `class_interaction` VALUES ('14', '1', '2025-11-10', '4', '2025-11-10');
INSERT INTO `class_interaction` VALUES ('15', '1', '2025-11-09', '3', '2025-11-09');
INSERT INTO `class_interaction` VALUES ('16', '1', '2025-11-08', '4', '2025-11-08');
INSERT INTO `class_interaction` VALUES ('17', '1', '2025-11-07', '5', '2025-11-07');
INSERT INTO `class_interaction` VALUES ('18', '1', '2025-11-06', '4', '2025-11-06');

-- ----------------------------
-- Table structure for class_interaction_seq
-- ----------------------------
DROP TABLE IF EXISTS `class_interaction_seq`;
CREATE TABLE `class_interaction_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of class_interaction_seq
-- ----------------------------
INSERT INTO `class_interaction_seq` VALUES ('1');

-- ----------------------------
-- Table structure for class_student
-- ----------------------------
DROP TABLE IF EXISTS `class_student`;
CREATE TABLE `class_student` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `class_id` bigint(20) NOT NULL,
  `student_id` bigint(20) NOT NULL,
  `joined_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_student` (`class_id`,`student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `class_student_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `clazz` (`id`) ON DELETE CASCADE,
  CONSTRAINT `class_student_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of class_student
-- ----------------------------
INSERT INTO `class_student` VALUES ('1', '1', '1', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('2', '1', '2', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('3', '1', '3', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('4', '1', '4', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('5', '1', '5', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('6', '1', '6', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('7', '1', '7', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('8', '1', '8', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('9', '1', '9', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('10', '1', '10', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('11', '1', '11', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('12', '1', '12', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('13', '1', '13', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('14', '1', '14', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('15', '1', '15', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('16', '1', '16', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('17', '1', '17', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('18', '1', '18', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('19', '1', '19', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('20', '1', '20', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('21', '1', '21', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('22', '1', '22', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('23', '1', '23', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('24', '1', '24', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('25', '1', '25', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('26', '1', '26', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('27', '1', '27', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('28', '1', '28', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('29', '1', '29', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('30', '1', '30', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('31', '1', '31', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('32', '1', '32', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('33', '1', '33', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('34', '1', '34', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('35', '1', '35', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('36', '1', '36', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('37', '1', '37', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('38', '1', '38', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('39', '1', '39', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('40', '1', '40', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('41', '1', '41', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('42', '1', '42', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('43', '1', '43', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('44', '1', '44', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('45', '1', '45', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('46', '1', '46', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('47', '1', '47', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('48', '1', '48', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('49', '1', '49', '2025-11-20 18:53:44');
INSERT INTO `class_student` VALUES ('50', '1', '50', '2025-11-20 18:53:44');

-- ----------------------------
-- Table structure for clazz
-- ----------------------------
DROP TABLE IF EXISTS `clazz`;
CREATE TABLE `clazz` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `invite_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `clazz_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of clazz
-- ----------------------------
INSERT INTO `clazz` VALUES ('1', '1', '七年级语文1班', 'ABC123');
INSERT INTO `clazz` VALUES ('2', '1', '七年级语文2班', 'DEF456');
INSERT INTO `clazz` VALUES ('3', '2', '七年级数学1班', 'GHI789');
INSERT INTO `clazz` VALUES ('4', '3', '八年级英语1班', 'JKL012');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `teacher_id` bigint(20) DEFAULT NULL,
  `semester` varchar(100) DEFAULT NULL,
  `invite_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('1', '七年级语文', '1', '2024-2025学年第一学期', 'CHINESE2024');
INSERT INTO `course` VALUES ('2', '七年级数学', '1', '2024-2025学年第一学期', 'MATH2024');
INSERT INTO `course` VALUES ('3', '八年级英语', '2', '2024-2025学年第一学期', 'ENGLISH2024');

-- ----------------------------
-- Table structure for evaluation
-- ----------------------------
DROP TABLE IF EXISTS `evaluation`;
CREATE TABLE `evaluation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `clazz_id` bigint(20) DEFAULT NULL,
  `student_id` varchar(100) NOT NULL,
  `score_content` int(11) DEFAULT NULL,
  `score_method` int(11) DEFAULT NULL,
  `score_attitude` int(11) DEFAULT NULL,
  `score_effect` int(11) DEFAULT NULL,
  `score_homework` int(11) DEFAULT NULL,
  `comment` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `clazz_id` (`clazz_id`),
  CONSTRAINT `evaluation_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `evaluation_ibfk_2` FOREIGN KEY (`clazz_id`) REFERENCES `clazz` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of evaluation
-- ----------------------------
INSERT INTO `evaluation` VALUES ('1', '1', '1', '1', '90', '85', '88', '87', '90', '老师讲课很生动，课堂氛围很好', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('2', '1', '1', '2', '75', '80', '85', '78', '75', '希望能多讲解一些难点', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('3', '1', '1', '4', '92', '90', '95', '93', '92', '老师讲解非常清晰，受益匪浅', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('4', '1', '1', '5', '78', '75', '80', '77', '78', '课程内容不错，但希望能有更多练习', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('5', '1', '1', '6', '85', '82', '88', '86', '85', '课堂互动很好，学习效果不错', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('6', '1', '2', '3', '82', '85', '88', '85', '80', '课程内容很丰富，受益匪浅', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('7', '1', '2', '7', '70', '72', '75', '73', '70', '希望能放慢讲课速度', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('8', '1', '2', '8', '83', '80', '85', '82', '83', '老师很负责，讲解详细', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('9', '2', '3', '1', '88', '90', '85', '87', '88', '数学老师讲解清晰，容易理解', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('10', '2', '3', '9', '85', '82', '88', '86', '85', '数学课程很有趣，逻辑清晰', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('11', '2', '3', '10', '78', '75', '80', '77', '78', '需要更多练习来巩固知识', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('12', '2', '3', '11', '92', '90', '95', '93', '92', '数学老师教学方法很好，容易理解', '2025-11-20 18:53:44');
INSERT INTO `evaluation` VALUES ('13', '3', '4', '12', '88', '85', '90', '87', '88', '英语老师发音标准，课堂氛围活跃', '2025-11-20 18:53:44');

-- ----------------------------
-- Table structure for evaluation_seq
-- ----------------------------
DROP TABLE IF EXISTS `evaluation_seq`;
CREATE TABLE `evaluation_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of evaluation_seq
-- ----------------------------
INSERT INTO `evaluation_seq` VALUES ('1');

-- ----------------------------
-- Table structure for eval_course
-- ----------------------------
DROP TABLE IF EXISTS `eval_course`;
CREATE TABLE `eval_course` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `teacher_name` varchar(255) DEFAULT NULL,
  `semester` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of eval_course
-- ----------------------------

-- ----------------------------
-- Table structure for eval_course_seq
-- ----------------------------
DROP TABLE IF EXISTS `eval_course_seq`;
CREATE TABLE `eval_course_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of eval_course_seq
-- ----------------------------
INSERT INTO `eval_course_seq` VALUES ('1');

-- ----------------------------
-- Table structure for homework
-- ----------------------------
DROP TABLE IF EXISTS `homework`;
CREATE TABLE `homework` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `knowledge_point` varchar(255) DEFAULT NULL,
  `difficulty` varchar(50) DEFAULT NULL,
  `question` text,
  `answer` text,
  `clazz_id` bigint(20) DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `type` varchar(50) DEFAULT 'answer',
  `options` text,
  `target_layer` varchar(50) DEFAULT NULL COMMENT '目标层级：基础层、提高层、拓展层',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `md5` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `clazz_id` (`clazz_id`),
  CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_2` FOREIGN KEY (`clazz_id`) REFERENCES `clazz` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of homework
-- ----------------------------
INSERT INTO `homework` VALUES ('1', '1', '现代文阅读', 'medium', '《春》朱自清-文章主旨理解', '表达了作者对春天的热爱和对美好生活的向往', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '3602fa5c3e2cced70094525d916c7db3');
INSERT INTO `homework` VALUES ('2', '1', '文言文', 'hard', '《陋室铭》刘禹锡-文言实词理解', '陋：简陋', null, '1', 'answer', null, null, '2025-11-20 18:53:44', 'bcc5a5ad435e9c69950cf56c0e3b526c');
INSERT INTO `homework` VALUES ('3', '1', '作文写作', 'medium', '作文-议论文论证结构', '总分总结构', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '80da02c0ec3511802b050beb4eb6161e');
INSERT INTO `homework` VALUES ('4', '1', '诗词鉴赏', 'medium', '《观沧海》曹操-诗歌意境分析', '表达了诗人博大的胸襟和远大的政治抱负', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '9860cca58b4252aa65dfefdaa4e5e2c6');
INSERT INTO `homework` VALUES ('5', '1', '基础知识', 'easy', '病句修改-语序不当', '调整语序使句子通顺', null, '1', 'answer', null, null, '2025-11-20 18:53:44', 'e242cd35dc4a826778cb426004de3e28');
INSERT INTO `homework` VALUES ('6', '1', '现代文阅读', 'medium', '《背影》朱自清-细节描写作用', '通过细节描写表现父爱的深沉', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '77ed646211120d8faf6867c00ff96c4d');
INSERT INTO `homework` VALUES ('7', '1', '基础知识', 'easy', '标点符号使用-引号用法', '引号用于引用或强调', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '09bc1adcde1816d71e78c6ecb57f689a');
INSERT INTO `homework` VALUES ('8', '1', '文言文', 'hard', '《桃花源记》陶渊明-文言句式', '判断句、倒装句等', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '3aaf4363aea5b18fe3fedf98e21c5a20');
INSERT INTO `homework` VALUES ('9', '1', '现代文阅读', 'medium', '说明文-说明方法及作用', '举例子、列数字、作比较等', null, '1', 'answer', null, null, '2025-11-20 18:53:44', 'f9674e206d2224c3b16d8ff7537151e3');
INSERT INTO `homework` VALUES ('10', '1', '作文写作', 'medium', '作文-记叙文情感表达', '通过细节描写表达真情实感', null, '1', 'answer', null, null, '2025-11-20 18:53:44', '9166107e54f93bccd2336964bc5b39f0');

-- ----------------------------
-- Table structure for homework_score
-- ----------------------------
DROP TABLE IF EXISTS `homework_score`;
CREATE TABLE `homework_score` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `student_id` varchar(100) NOT NULL,
  `knowledge_point` varchar(255) DEFAULT NULL,
  `score` int(11) NOT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_knowledge_point` (`knowledge_point`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_course_student` (`course_id`,`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=456 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of homework_score
-- ----------------------------
INSERT INTO `homework_score` VALUES ('1', '1', '1', '阅读理解', '96', '2025-11-20');
INSERT INTO `homework_score` VALUES ('2', '1', '1', '文言文', '94', '2025-11-20');
INSERT INTO `homework_score` VALUES ('3', '1', '1', '现代文阅读', '97', '2025-11-20');
INSERT INTO `homework_score` VALUES ('4', '1', '1', '作文写作', '93', '2025-11-19');
INSERT INTO `homework_score` VALUES ('5', '1', '1', '基础知识', '98', '2025-11-19');
INSERT INTO `homework_score` VALUES ('6', '1', '1', '诗词鉴赏', '95', '2025-11-18');
INSERT INTO `homework_score` VALUES ('7', '1', '4', '阅读理解', '95', '2025-11-20');
INSERT INTO `homework_score` VALUES ('8', '1', '4', '文言文', '92', '2025-11-20');
INSERT INTO `homework_score` VALUES ('9', '1', '4', '现代文阅读', '96', '2025-11-20');
INSERT INTO `homework_score` VALUES ('10', '1', '4', '作文写作', '94', '2025-11-19');
INSERT INTO `homework_score` VALUES ('11', '1', '4', '基础知识', '93', '2025-11-19');
INSERT INTO `homework_score` VALUES ('12', '1', '4', '诗词鉴赏', '94', '2025-11-18');
INSERT INTO `homework_score` VALUES ('13', '1', '6', '阅读理解', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('14', '1', '6', '文言文', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('15', '1', '6', '现代文阅读', '93', '2025-11-20');
INSERT INTO `homework_score` VALUES ('16', '1', '6', '作文写作', '92', '2025-11-19');
INSERT INTO `homework_score` VALUES ('17', '1', '6', '基础知识', '94', '2025-11-19');
INSERT INTO `homework_score` VALUES ('18', '1', '6', '诗词鉴赏', '91', '2025-11-18');
INSERT INTO `homework_score` VALUES ('19', '1', '13', '阅读理解', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('20', '1', '13', '文言文', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('21', '1', '13', '现代文阅读', '92', '2025-11-20');
INSERT INTO `homework_score` VALUES ('22', '1', '13', '作文写作', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('23', '1', '13', '基础知识', '93', '2025-11-19');
INSERT INTO `homework_score` VALUES ('24', '1', '13', '诗词鉴赏', '90', '2025-11-18');
INSERT INTO `homework_score` VALUES ('25', '1', '14', '阅读理解', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('26', '1', '14', '文言文', '89', '2025-11-20');
INSERT INTO `homework_score` VALUES ('27', '1', '14', '现代文阅读', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('28', '1', '14', '作文写作', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('29', '1', '14', '基础知识', '91', '2025-11-19');
INSERT INTO `homework_score` VALUES ('30', '1', '14', '诗词鉴赏', '90', '2025-11-18');
INSERT INTO `homework_score` VALUES ('31', '1', '15', '阅读理解', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('32', '1', '15', '文言文', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('33', '1', '15', '现代文阅读', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('34', '1', '15', '作文写作', '89', '2025-11-19');
INSERT INTO `homework_score` VALUES ('35', '1', '15', '基础知识', '91', '2025-11-19');
INSERT INTO `homework_score` VALUES ('36', '1', '15', '诗词鉴赏', '90', '2025-11-18');
INSERT INTO `homework_score` VALUES ('37', '1', '16', '阅读理解', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('38', '1', '16', '文言文', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('39', '1', '16', '现代文阅读', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('40', '1', '16', '作文写作', '89', '2025-11-19');
INSERT INTO `homework_score` VALUES ('41', '1', '16', '基础知识', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('42', '1', '16', '诗词鉴赏', '90', '2025-11-18');
INSERT INTO `homework_score` VALUES ('43', '1', '17', '阅读理解', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('44', '1', '17', '文言文', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('45', '1', '17', '现代文阅读', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('46', '1', '17', '作文写作', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('47', '1', '17', '基础知识', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('48', '1', '17', '诗词鉴赏', '90', '2025-11-18');
INSERT INTO `homework_score` VALUES ('49', '1', '3', '阅读理解', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('50', '1', '3', '文言文', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('51', '1', '3', '现代文阅读', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('52', '1', '3', '作文写作', '84', '2025-11-19');
INSERT INTO `homework_score` VALUES ('53', '1', '3', '基础知识', '87', '2025-11-19');
INSERT INTO `homework_score` VALUES ('54', '1', '3', '诗词鉴赏', '83', '2025-11-18');
INSERT INTO `homework_score` VALUES ('55', '1', '8', '阅读理解', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('56', '1', '8', '文言文', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('57', '1', '8', '现代文阅读', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('58', '1', '8', '作文写作', '83', '2025-11-19');
INSERT INTO `homework_score` VALUES ('59', '1', '8', '基础知识', '85', '2025-11-19');
INSERT INTO `homework_score` VALUES ('60', '1', '8', '诗词鉴赏', '84', '2025-11-18');
INSERT INTO `homework_score` VALUES ('61', '1', '18', '阅读理解', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('62', '1', '18', '文言文', '81', '2025-11-20');
INSERT INTO `homework_score` VALUES ('63', '1', '18', '现代文阅读', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('64', '1', '19', '阅读理解', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('65', '1', '19', '文言文', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('66', '1', '19', '现代文阅读', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('67', '1', '20', '阅读理解', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('68', '1', '20', '文言文', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('69', '1', '20', '现代文阅读', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('70', '1', '21', '阅读理解', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('71', '1', '21', '文言文', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('72', '1', '21', '现代文阅读', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('73', '1', '22', '阅读理解', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('74', '1', '22', '文言文', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('75', '1', '22', '现代文阅读', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('76', '1', '23', '阅读理解', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('77', '1', '23', '文言文', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('78', '1', '23', '现代文阅读', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('79', '1', '24', '阅读理解', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('80', '1', '24', '文言文', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('81', '1', '24', '现代文阅读', '89', '2025-11-20');
INSERT INTO `homework_score` VALUES ('82', '1', '25', '阅读理解', '81', '2025-11-20');
INSERT INTO `homework_score` VALUES ('83', '1', '25', '文言文', '80', '2025-11-20');
INSERT INTO `homework_score` VALUES ('84', '1', '25', '现代文阅读', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('85', '1', '26', '阅读理解', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('86', '1', '26', '文言文', '81', '2025-11-20');
INSERT INTO `homework_score` VALUES ('87', '1', '26', '现代文阅读', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('88', '1', '27', '阅读理解', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('89', '1', '27', '文言文', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('90', '1', '27', '现代文阅读', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('91', '1', '28', '阅读理解', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('92', '1', '28', '文言文', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('93', '1', '28', '现代文阅读', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('94', '1', '29', '阅读理解', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('95', '1', '29', '文言文', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('96', '1', '29', '现代文阅读', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('97', '1', '44', '阅读理解', '80', '2025-11-20');
INSERT INTO `homework_score` VALUES ('98', '1', '44', '文言文', '81', '2025-11-20');
INSERT INTO `homework_score` VALUES ('99', '1', '44', '现代文阅读', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('100', '1', '45', '阅读理解', '81', '2025-11-20');
INSERT INTO `homework_score` VALUES ('101', '1', '45', '文言文', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('102', '1', '45', '现代文阅读', '83', '2025-11-20');
INSERT INTO `homework_score` VALUES ('103', '1', '5', '阅读理解', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('104', '1', '5', '文言文', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('105', '1', '5', '现代文阅读', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('106', '1', '5', '作文写作', '75', '2025-11-19');
INSERT INTO `homework_score` VALUES ('107', '1', '5', '基础知识', '78', '2025-11-19');
INSERT INTO `homework_score` VALUES ('108', '1', '5', '诗词鉴赏', '75', '2025-11-18');
INSERT INTO `homework_score` VALUES ('109', '1', '30', '阅读理解', '70', '2025-11-20');
INSERT INTO `homework_score` VALUES ('110', '1', '30', '文言文', '71', '2025-11-20');
INSERT INTO `homework_score` VALUES ('111', '1', '30', '现代文阅读', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('112', '1', '31', '阅读理解', '71', '2025-11-20');
INSERT INTO `homework_score` VALUES ('113', '1', '31', '文言文', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('114', '1', '31', '现代文阅读', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('115', '1', '32', '阅读理解', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('116', '1', '32', '文言文', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('117', '1', '32', '现代文阅读', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('118', '1', '33', '阅读理解', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('119', '1', '33', '文言文', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('120', '1', '33', '现代文阅读', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('121', '1', '34', '阅读理解', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('122', '1', '34', '文言文', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('123', '1', '34', '现代文阅读', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('124', '1', '35', '阅读理解', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('125', '1', '35', '文言文', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('126', '1', '35', '现代文阅读', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('127', '1', '36', '阅读理解', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('128', '1', '36', '文言文', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('129', '1', '36', '现代文阅读', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('130', '1', '37', '阅读理解', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('131', '1', '37', '文言文', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('132', '1', '37', '现代文阅读', '79', '2025-11-20');
INSERT INTO `homework_score` VALUES ('133', '1', '38', '阅读理解', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('134', '1', '38', '文言文', '79', '2025-11-20');
INSERT INTO `homework_score` VALUES ('135', '1', '38', '现代文阅读', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('136', '1', '39', '阅读理解', '79', '2025-11-20');
INSERT INTO `homework_score` VALUES ('137', '1', '39', '文言文', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('138', '1', '39', '现代文阅读', '79', '2025-11-20');
INSERT INTO `homework_score` VALUES ('139', '1', '40', '阅读理解', '70', '2025-11-20');
INSERT INTO `homework_score` VALUES ('140', '1', '40', '文言文', '71', '2025-11-20');
INSERT INTO `homework_score` VALUES ('141', '1', '40', '现代文阅读', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('142', '1', '41', '阅读理解', '71', '2025-11-20');
INSERT INTO `homework_score` VALUES ('143', '1', '41', '文言文', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('144', '1', '41', '现代文阅读', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('145', '1', '42', '阅读理解', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('146', '1', '42', '文言文', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('147', '1', '42', '现代文阅读', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('148', '1', '43', '阅读理解', '73', '2025-11-20');
INSERT INTO `homework_score` VALUES ('149', '1', '43', '文言文', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('150', '1', '43', '现代文阅读', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('151', '1', '44', '阅读理解', '74', '2025-11-20');
INSERT INTO `homework_score` VALUES ('152', '1', '44', '文言文', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('153', '1', '44', '现代文阅读', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('154', '1', '45', '阅读理解', '75', '2025-11-20');
INSERT INTO `homework_score` VALUES ('155', '1', '45', '文言文', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('156', '1', '45', '现代文阅读', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('157', '1', '46', '阅读理解', '76', '2025-11-20');
INSERT INTO `homework_score` VALUES ('158', '1', '46', '文言文', '77', '2025-11-20');
INSERT INTO `homework_score` VALUES ('159', '1', '46', '现代文阅读', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('160', '1', '2', '阅读理解', '65', '2025-11-20');
INSERT INTO `homework_score` VALUES ('161', '1', '2', '文言文', '64', '2025-11-20');
INSERT INTO `homework_score` VALUES ('162', '1', '2', '现代文阅读', '66', '2025-11-20');
INSERT INTO `homework_score` VALUES ('163', '1', '2', '作文写作', '65', '2025-11-19');
INSERT INTO `homework_score` VALUES ('164', '1', '2', '基础知识', '67', '2025-11-19');
INSERT INTO `homework_score` VALUES ('165', '1', '2', '诗词鉴赏', '64', '2025-11-18');
INSERT INTO `homework_score` VALUES ('166', '1', '47', '阅读理解', '60', '2025-11-20');
INSERT INTO `homework_score` VALUES ('167', '1', '47', '文言文', '61', '2025-11-20');
INSERT INTO `homework_score` VALUES ('168', '1', '47', '现代文阅读', '62', '2025-11-20');
INSERT INTO `homework_score` VALUES ('169', '1', '48', '阅读理解', '61', '2025-11-20');
INSERT INTO `homework_score` VALUES ('170', '1', '48', '文言文', '62', '2025-11-20');
INSERT INTO `homework_score` VALUES ('171', '1', '48', '现代文阅读', '63', '2025-11-20');
INSERT INTO `homework_score` VALUES ('172', '1', '49', '阅读理解', '62', '2025-11-20');
INSERT INTO `homework_score` VALUES ('173', '1', '49', '文言文', '63', '2025-11-20');
INSERT INTO `homework_score` VALUES ('174', '1', '49', '现代文阅读', '64', '2025-11-20');
INSERT INTO `homework_score` VALUES ('175', '1', '50', '阅读理解', '63', '2025-11-20');
INSERT INTO `homework_score` VALUES ('176', '1', '50', '文言文', '64', '2025-11-20');
INSERT INTO `homework_score` VALUES ('177', '1', '50', '现代文阅读', '65', '2025-11-20');
INSERT INTO `homework_score` VALUES ('178', '1', '12', '阅读理解', '68', '2025-11-20');
INSERT INTO `homework_score` VALUES ('179', '1', '12', '文言文', '67', '2025-11-20');
INSERT INTO `homework_score` VALUES ('180', '1', '12', '现代文阅读', '69', '2025-11-20');
INSERT INTO `homework_score` VALUES ('181', '1', '7', '阅读理解', '55', '2025-11-20');
INSERT INTO `homework_score` VALUES ('182', '1', '7', '文言文', '54', '2025-11-20');
INSERT INTO `homework_score` VALUES ('183', '1', '7', '现代文阅读', '56', '2025-11-20');
INSERT INTO `homework_score` VALUES ('184', '1', '7', '作文写作', '55', '2025-11-19');
INSERT INTO `homework_score` VALUES ('185', '1', '7', '基础知识', '57', '2025-11-19');
INSERT INTO `homework_score` VALUES ('186', '1', '7', '诗词鉴赏', '53', '2025-11-18');
INSERT INTO `homework_score` VALUES ('187', '1', '9', '阅读理解', '50', '2025-11-20');
INSERT INTO `homework_score` VALUES ('188', '1', '9', '文言文', '51', '2025-11-20');
INSERT INTO `homework_score` VALUES ('189', '1', '9', '现代文阅读', '52', '2025-11-20');
INSERT INTO `homework_score` VALUES ('190', '1', '10', '阅读理解', '51', '2025-11-20');
INSERT INTO `homework_score` VALUES ('191', '1', '10', '文言文', '52', '2025-11-20');
INSERT INTO `homework_score` VALUES ('192', '1', '10', '现代文阅读', '53', '2025-11-20');
INSERT INTO `homework_score` VALUES ('193', '1', '11', '阅读理解', '52', '2025-11-20');
INSERT INTO `homework_score` VALUES ('194', '1', '11', '文言文', '53', '2025-11-20');
INSERT INTO `homework_score` VALUES ('195', '1', '11', '现代文阅读', '54', '2025-11-20');
INSERT INTO `homework_score` VALUES ('196', '2', '1', '整数运算', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('197', '2', '1', '分数运算', '88', '2025-11-19');
INSERT INTO `homework_score` VALUES ('198', '2', '2', '整数运算', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('199', '2', '2', '分数运算', '68', '2025-11-19');
INSERT INTO `homework_score` VALUES ('200', '2', '9', '整数运算', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('201', '2', '9', '分数运算', '82', '2025-11-19');
INSERT INTO `homework_score` VALUES ('202', '2', '10', '整数运算', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('203', '2', '10', '分数运算', '75', '2025-11-19');
INSERT INTO `homework_score` VALUES ('204', '2', '11', '整数运算', '92', '2025-11-20');
INSERT INTO `homework_score` VALUES ('205', '2', '11', '分数运算', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('206', '3', '12', '词汇', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('207', '3', '12', '语法', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('208', '3', '12', '阅读理解', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('209', '1', '1', '阅读理解', '94', '2025-11-17');
INSERT INTO `homework_score` VALUES ('210', '1', '1', '文言文', '96', '2025-11-17');
INSERT INTO `homework_score` VALUES ('211', '1', '1', '现代文阅读', '95', '2025-11-16');
INSERT INTO `homework_score` VALUES ('212', '1', '1', '作文写作', '92', '2025-11-16');
INSERT INTO `homework_score` VALUES ('213', '1', '1', '基础知识', '97', '2025-11-15');
INSERT INTO `homework_score` VALUES ('214', '1', '1', '诗词鉴赏', '94', '2025-11-15');
INSERT INTO `homework_score` VALUES ('215', '1', '4', '阅读理解', '94', '2025-11-17');
INSERT INTO `homework_score` VALUES ('216', '1', '4', '文言文', '93', '2025-11-17');
INSERT INTO `homework_score` VALUES ('217', '1', '4', '现代文阅读', '95', '2025-11-16');
INSERT INTO `homework_score` VALUES ('218', '1', '4', '作文写作', '93', '2025-11-16');
INSERT INTO `homework_score` VALUES ('219', '1', '4', '基础知识', '92', '2025-11-15');
INSERT INTO `homework_score` VALUES ('220', '1', '4', '诗词鉴赏', '95', '2025-11-15');
INSERT INTO `homework_score` VALUES ('221', '1', '6', '阅读理解', '92', '2025-11-17');
INSERT INTO `homework_score` VALUES ('222', '1', '6', '文言文', '91', '2025-11-17');
INSERT INTO `homework_score` VALUES ('223', '1', '6', '现代文阅读', '94', '2025-11-16');
INSERT INTO `homework_score` VALUES ('224', '1', '6', '作文写作', '91', '2025-11-16');
INSERT INTO `homework_score` VALUES ('225', '1', '6', '基础知识', '93', '2025-11-15');
INSERT INTO `homework_score` VALUES ('226', '1', '6', '诗词鉴赏', '90', '2025-11-15');
INSERT INTO `homework_score` VALUES ('227', '1', '13', '阅读理解', '91', '2025-11-17');
INSERT INTO `homework_score` VALUES ('228', '1', '13', '文言文', '90', '2025-11-17');
INSERT INTO `homework_score` VALUES ('229', '1', '13', '现代文阅读', '91', '2025-11-16');
INSERT INTO `homework_score` VALUES ('230', '1', '13', '作文写作', '89', '2025-11-16');
INSERT INTO `homework_score` VALUES ('231', '1', '13', '基础知识', '92', '2025-11-15');
INSERT INTO `homework_score` VALUES ('232', '1', '13', '诗词鉴赏', '91', '2025-11-15');
INSERT INTO `homework_score` VALUES ('233', '1', '14', '阅读理解', '89', '2025-11-17');
INSERT INTO `homework_score` VALUES ('234', '1', '14', '文言文', '90', '2025-11-17');
INSERT INTO `homework_score` VALUES ('235', '1', '14', '现代文阅读', '90', '2025-11-16');
INSERT INTO `homework_score` VALUES ('236', '1', '14', '作文写作', '91', '2025-11-16');
INSERT INTO `homework_score` VALUES ('237', '1', '14', '基础知识', '90', '2025-11-15');
INSERT INTO `homework_score` VALUES ('238', '1', '14', '诗词鉴赏', '89', '2025-11-15');
INSERT INTO `homework_score` VALUES ('239', '1', '1', '阅读理解', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('240', '1', '1', '文言文', '72', '2025-11-20');
INSERT INTO `homework_score` VALUES ('241', '1', '1', '现代文阅读', '78', '2025-11-20');
INSERT INTO `homework_score` VALUES ('242', '1', '1', '作文写作', '68', '2025-11-20');
INSERT INTO `homework_score` VALUES ('243', '1', '1', '诗词鉴赏', '65', '2025-11-20');
INSERT INTO `homework_score` VALUES ('244', '1', '1', '基础知识', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('245', '1', '1', '阅读理解', '95', '2025-11-14');
INSERT INTO `homework_score` VALUES ('246', '1', '1', '文言文', '93', '2025-11-14');
INSERT INTO `homework_score` VALUES ('247', '1', '1', '现代文阅读', '96', '2025-11-13');
INSERT INTO `homework_score` VALUES ('248', '1', '1', '作文写作', '94', '2025-11-13');
INSERT INTO `homework_score` VALUES ('249', '1', '1', '基础知识', '96', '2025-11-12');
INSERT INTO `homework_score` VALUES ('250', '1', '1', '诗词鉴赏', '94', '2025-11-12');
INSERT INTO `homework_score` VALUES ('251', '1', '1', '阅读理解', '96', '2025-11-11');
INSERT INTO `homework_score` VALUES ('252', '1', '1', '文言文', '95', '2025-11-11');
INSERT INTO `homework_score` VALUES ('253', '1', '1', '现代文阅读', '97', '2025-11-10');
INSERT INTO `homework_score` VALUES ('254', '1', '1', '作文写作', '95', '2025-11-10');
INSERT INTO `homework_score` VALUES ('255', '1', '4', '阅读理解', '94', '2025-11-14');
INSERT INTO `homework_score` VALUES ('256', '1', '4', '文言文', '91', '2025-11-14');
INSERT INTO `homework_score` VALUES ('257', '1', '4', '现代文阅读', '95', '2025-11-13');
INSERT INTO `homework_score` VALUES ('258', '1', '4', '作文写作', '93', '2025-11-13');
INSERT INTO `homework_score` VALUES ('259', '1', '4', '基础知识', '94', '2025-11-12');
INSERT INTO `homework_score` VALUES ('260', '1', '4', '诗词鉴赏', '93', '2025-11-12');
INSERT INTO `homework_score` VALUES ('261', '1', '4', '阅读理解', '95', '2025-11-11');
INSERT INTO `homework_score` VALUES ('262', '1', '4', '文言文', '93', '2025-11-11');
INSERT INTO `homework_score` VALUES ('263', '1', '4', '现代文阅读', '96', '2025-11-10');
INSERT INTO `homework_score` VALUES ('264', '1', '4', '作文写作', '94', '2025-11-10');
INSERT INTO `homework_score` VALUES ('265', '1', '6', '阅读理解', '92', '2025-11-14');
INSERT INTO `homework_score` VALUES ('266', '1', '6', '文言文', '89', '2025-11-14');
INSERT INTO `homework_score` VALUES ('267', '1', '6', '现代文阅读', '93', '2025-11-13');
INSERT INTO `homework_score` VALUES ('268', '1', '6', '作文写作', '91', '2025-11-13');
INSERT INTO `homework_score` VALUES ('269', '1', '6', '基础知识', '93', '2025-11-12');
INSERT INTO `homework_score` VALUES ('270', '1', '6', '诗词鉴赏', '90', '2025-11-12');
INSERT INTO `homework_score` VALUES ('271', '1', '6', '阅读理解', '91', '2025-11-11');
INSERT INTO `homework_score` VALUES ('272', '1', '6', '文言文', '90', '2025-11-11');
INSERT INTO `homework_score` VALUES ('273', '1', '6', '现代文阅读', '92', '2025-11-10');
INSERT INTO `homework_score` VALUES ('274', '1', '6', '作文写作', '92', '2025-11-10');
INSERT INTO `homework_score` VALUES ('275', '1', '13', '阅读理解', '91', '2025-11-14');
INSERT INTO `homework_score` VALUES ('276', '1', '13', '文言文', '90', '2025-11-14');
INSERT INTO `homework_score` VALUES ('277', '1', '13', '现代文阅读', '92', '2025-11-13');
INSERT INTO `homework_score` VALUES ('278', '1', '13', '作文写作', '90', '2025-11-13');
INSERT INTO `homework_score` VALUES ('279', '1', '13', '基础知识', '92', '2025-11-12');
INSERT INTO `homework_score` VALUES ('280', '1', '13', '诗词鉴赏', '90', '2025-11-12');
INSERT INTO `homework_score` VALUES ('281', '1', '13', '阅读理解', '90', '2025-11-11');
INSERT INTO `homework_score` VALUES ('282', '1', '13', '文言文', '91', '2025-11-11');
INSERT INTO `homework_score` VALUES ('283', '1', '13', '现代文阅读', '91', '2025-11-10');
INSERT INTO `homework_score` VALUES ('284', '1', '13', '作文写作', '89', '2025-11-10');
INSERT INTO `homework_score` VALUES ('285', '1', '14', '阅读理解', '90', '2025-11-14');
INSERT INTO `homework_score` VALUES ('286', '1', '14', '文言文', '88', '2025-11-14');
INSERT INTO `homework_score` VALUES ('287', '1', '14', '现代文阅读', '91', '2025-11-13');
INSERT INTO `homework_score` VALUES ('288', '1', '14', '作文写作', '89', '2025-11-13');
INSERT INTO `homework_score` VALUES ('289', '1', '14', '基础知识', '90', '2025-11-12');
INSERT INTO `homework_score` VALUES ('290', '1', '14', '诗词鉴赏', '89', '2025-11-12');
INSERT INTO `homework_score` VALUES ('291', '1', '14', '阅读理解', '89', '2025-11-11');
INSERT INTO `homework_score` VALUES ('292', '1', '14', '文言文', '90', '2025-11-11');
INSERT INTO `homework_score` VALUES ('293', '1', '14', '现代文阅读', '90', '2025-11-10');
INSERT INTO `homework_score` VALUES ('294', '1', '14', '作文写作', '90', '2025-11-10');
INSERT INTO `homework_score` VALUES ('295', '1', '1', '阅读理解', '92', '2025-11-20');
INSERT INTO `homework_score` VALUES ('296', '1', '1', '文言文', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('297', '1', '1', '现代文阅读', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('298', '1', '2', '阅读理解', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('299', '1', '2', '文言文', '82', '2025-11-20');
INSERT INTO `homework_score` VALUES ('300', '1', '2', '现代文阅读', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('301', '1', '3', '阅读理解', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('302', '1', '3', '作文写作', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('303', '1', '4', '阅读理解', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('304', '1', '4', '文言文', '89', '2025-11-20');
INSERT INTO `homework_score` VALUES ('305', '1', '4', '现代文阅读', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('306', '1', '5', '阅读理解', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('307', '1', '5', '基础知识', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('308', '1', '6', '阅读理解', '89', '2025-11-20');
INSERT INTO `homework_score` VALUES ('309', '1', '6', '文言文', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('310', '1', '7', '阅读理解', '84', '2025-11-20');
INSERT INTO `homework_score` VALUES ('311', '1', '7', '现代文阅读', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('312', '1', '8', '阅读理解', '87', '2025-11-20');
INSERT INTO `homework_score` VALUES ('313', '1', '8', '作文写作', '85', '2025-11-20');
INSERT INTO `homework_score` VALUES ('314', '1', '9', '阅读理解', '91', '2025-11-20');
INSERT INTO `homework_score` VALUES ('315', '1', '9', '文言文', '90', '2025-11-20');
INSERT INTO `homework_score` VALUES ('316', '1', '10', '阅读理解', '88', '2025-11-20');
INSERT INTO `homework_score` VALUES ('317', '1', '10', '基础知识', '86', '2025-11-20');
INSERT INTO `homework_score` VALUES ('318', '1', '1', '阅读理解', '90', '2025-11-19');
INSERT INTO `homework_score` VALUES ('319', '1', '1', '文言文', '86', '2025-11-19');
INSERT INTO `homework_score` VALUES ('320', '1', '1', '现代文阅读', '88', '2025-11-19');
INSERT INTO `homework_score` VALUES ('321', '1', '2', '阅读理解', '83', '2025-11-19');
INSERT INTO `homework_score` VALUES ('322', '1', '2', '文言文', '80', '2025-11-19');
INSERT INTO `homework_score` VALUES ('323', '1', '2', '现代文阅读', '85', '2025-11-19');
INSERT INTO `homework_score` VALUES ('324', '1', '3', '阅读理解', '86', '2025-11-19');
INSERT INTO `homework_score` VALUES ('325', '1', '3', '作文写作', '83', '2025-11-19');
INSERT INTO `homework_score` VALUES ('326', '1', '4', '阅读理解', '88', '2025-11-19');
INSERT INTO `homework_score` VALUES ('327', '1', '4', '文言文', '87', '2025-11-19');
INSERT INTO `homework_score` VALUES ('328', '1', '4', '现代文阅读', '89', '2025-11-19');
INSERT INTO `homework_score` VALUES ('329', '1', '5', '阅读理解', '84', '2025-11-19');
INSERT INTO `homework_score` VALUES ('330', '1', '5', '基础知识', '86', '2025-11-19');
INSERT INTO `homework_score` VALUES ('331', '1', '6', '阅读理解', '87', '2025-11-19');
INSERT INTO `homework_score` VALUES ('332', '1', '6', '文言文', '85', '2025-11-19');
INSERT INTO `homework_score` VALUES ('333', '1', '7', '阅读理解', '82', '2025-11-19');
INSERT INTO `homework_score` VALUES ('334', '1', '7', '现代文阅读', '84', '2025-11-19');
INSERT INTO `homework_score` VALUES ('335', '1', '8', '阅读理解', '85', '2025-11-19');
INSERT INTO `homework_score` VALUES ('336', '1', '8', '作文写作', '83', '2025-11-19');
INSERT INTO `homework_score` VALUES ('337', '1', '9', '阅读理解', '89', '2025-11-19');
INSERT INTO `homework_score` VALUES ('338', '1', '9', '文言文', '88', '2025-11-19');
INSERT INTO `homework_score` VALUES ('339', '1', '10', '阅读理解', '86', '2025-11-19');
INSERT INTO `homework_score` VALUES ('340', '1', '10', '基础知识', '84', '2025-11-19');
INSERT INTO `homework_score` VALUES ('341', '1', '1', '阅读理解', '89', '2025-11-18');
INSERT INTO `homework_score` VALUES ('342', '1', '1', '文言文', '85', '2025-11-18');
INSERT INTO `homework_score` VALUES ('343', '1', '1', '现代文阅读', '87', '2025-11-18');
INSERT INTO `homework_score` VALUES ('344', '1', '2', '阅读理解', '82', '2025-11-18');
INSERT INTO `homework_score` VALUES ('345', '1', '2', '文言文', '79', '2025-11-18');
INSERT INTO `homework_score` VALUES ('346', '1', '2', '现代文阅读', '84', '2025-11-18');
INSERT INTO `homework_score` VALUES ('347', '1', '3', '阅读理解', '85', '2025-11-18');
INSERT INTO `homework_score` VALUES ('348', '1', '3', '作文写作', '82', '2025-11-18');
INSERT INTO `homework_score` VALUES ('349', '1', '4', '阅读理解', '87', '2025-11-18');
INSERT INTO `homework_score` VALUES ('350', '1', '4', '文言文', '86', '2025-11-18');
INSERT INTO `homework_score` VALUES ('351', '1', '4', '现代文阅读', '88', '2025-11-18');
INSERT INTO `homework_score` VALUES ('352', '1', '5', '阅读理解', '83', '2025-11-18');
INSERT INTO `homework_score` VALUES ('353', '1', '5', '基础知识', '85', '2025-11-18');
INSERT INTO `homework_score` VALUES ('354', '1', '6', '阅读理解', '86', '2025-11-18');
INSERT INTO `homework_score` VALUES ('355', '1', '6', '文言文', '84', '2025-11-18');
INSERT INTO `homework_score` VALUES ('356', '1', '7', '阅读理解', '81', '2025-11-18');
INSERT INTO `homework_score` VALUES ('357', '1', '7', '现代文阅读', '83', '2025-11-18');
INSERT INTO `homework_score` VALUES ('358', '1', '8', '阅读理解', '84', '2025-11-18');
INSERT INTO `homework_score` VALUES ('359', '1', '8', '作文写作', '82', '2025-11-18');
INSERT INTO `homework_score` VALUES ('360', '1', '9', '阅读理解', '88', '2025-11-18');
INSERT INTO `homework_score` VALUES ('361', '1', '9', '文言文', '87', '2025-11-18');
INSERT INTO `homework_score` VALUES ('362', '1', '10', '阅读理解', '85', '2025-11-18');
INSERT INTO `homework_score` VALUES ('363', '1', '10', '基础知识', '83', '2025-11-18');
INSERT INTO `homework_score` VALUES ('364', '1', '1', '阅读理解', '88', '2025-11-17');
INSERT INTO `homework_score` VALUES ('365', '1', '1', '文言文', '84', '2025-11-17');
INSERT INTO `homework_score` VALUES ('366', '1', '1', '现代文阅读', '86', '2025-11-17');
INSERT INTO `homework_score` VALUES ('367', '1', '2', '阅读理解', '81', '2025-11-17');
INSERT INTO `homework_score` VALUES ('368', '1', '2', '文言文', '78', '2025-11-17');
INSERT INTO `homework_score` VALUES ('369', '1', '2', '现代文阅读', '83', '2025-11-17');
INSERT INTO `homework_score` VALUES ('370', '1', '3', '阅读理解', '84', '2025-11-17');
INSERT INTO `homework_score` VALUES ('371', '1', '3', '作文写作', '81', '2025-11-17');
INSERT INTO `homework_score` VALUES ('372', '1', '4', '阅读理解', '86', '2025-11-17');
INSERT INTO `homework_score` VALUES ('373', '1', '4', '文言文', '85', '2025-11-17');
INSERT INTO `homework_score` VALUES ('374', '1', '4', '现代文阅读', '87', '2025-11-17');
INSERT INTO `homework_score` VALUES ('375', '1', '5', '阅读理解', '82', '2025-11-17');
INSERT INTO `homework_score` VALUES ('376', '1', '5', '基础知识', '84', '2025-11-17');
INSERT INTO `homework_score` VALUES ('377', '1', '6', '阅读理解', '85', '2025-11-17');
INSERT INTO `homework_score` VALUES ('378', '1', '6', '文言文', '83', '2025-11-17');
INSERT INTO `homework_score` VALUES ('379', '1', '7', '阅读理解', '80', '2025-11-17');
INSERT INTO `homework_score` VALUES ('380', '1', '7', '现代文阅读', '82', '2025-11-17');
INSERT INTO `homework_score` VALUES ('381', '1', '8', '阅读理解', '83', '2025-11-17');
INSERT INTO `homework_score` VALUES ('382', '1', '8', '作文写作', '81', '2025-11-17');
INSERT INTO `homework_score` VALUES ('383', '1', '9', '阅读理解', '87', '2025-11-17');
INSERT INTO `homework_score` VALUES ('384', '1', '9', '文言文', '86', '2025-11-17');
INSERT INTO `homework_score` VALUES ('385', '1', '10', '阅读理解', '84', '2025-11-17');
INSERT INTO `homework_score` VALUES ('386', '1', '10', '基础知识', '82', '2025-11-17');
INSERT INTO `homework_score` VALUES ('387', '1', '1', '阅读理解', '87', '2025-11-16');
INSERT INTO `homework_score` VALUES ('388', '1', '1', '文言文', '83', '2025-11-16');
INSERT INTO `homework_score` VALUES ('389', '1', '1', '现代文阅读', '85', '2025-11-16');
INSERT INTO `homework_score` VALUES ('390', '1', '2', '阅读理解', '80', '2025-11-16');
INSERT INTO `homework_score` VALUES ('391', '1', '2', '文言文', '77', '2025-11-16');
INSERT INTO `homework_score` VALUES ('392', '1', '2', '现代文阅读', '82', '2025-11-16');
INSERT INTO `homework_score` VALUES ('393', '1', '3', '阅读理解', '83', '2025-11-16');
INSERT INTO `homework_score` VALUES ('394', '1', '3', '作文写作', '80', '2025-11-16');
INSERT INTO `homework_score` VALUES ('395', '1', '4', '阅读理解', '85', '2025-11-16');
INSERT INTO `homework_score` VALUES ('396', '1', '4', '文言文', '84', '2025-11-16');
INSERT INTO `homework_score` VALUES ('397', '1', '4', '现代文阅读', '86', '2025-11-16');
INSERT INTO `homework_score` VALUES ('398', '1', '5', '阅读理解', '81', '2025-11-16');
INSERT INTO `homework_score` VALUES ('399', '1', '5', '基础知识', '83', '2025-11-16');
INSERT INTO `homework_score` VALUES ('400', '1', '6', '阅读理解', '84', '2025-11-16');
INSERT INTO `homework_score` VALUES ('401', '1', '6', '文言文', '82', '2025-11-16');
INSERT INTO `homework_score` VALUES ('402', '1', '7', '阅读理解', '79', '2025-11-16');
INSERT INTO `homework_score` VALUES ('403', '1', '7', '现代文阅读', '81', '2025-11-16');
INSERT INTO `homework_score` VALUES ('404', '1', '8', '阅读理解', '82', '2025-11-16');
INSERT INTO `homework_score` VALUES ('405', '1', '8', '作文写作', '80', '2025-11-16');
INSERT INTO `homework_score` VALUES ('406', '1', '9', '阅读理解', '86', '2025-11-16');
INSERT INTO `homework_score` VALUES ('407', '1', '9', '文言文', '85', '2025-11-16');
INSERT INTO `homework_score` VALUES ('408', '1', '10', '阅读理解', '83', '2025-11-16');
INSERT INTO `homework_score` VALUES ('409', '1', '10', '基础知识', '81', '2025-11-16');
INSERT INTO `homework_score` VALUES ('410', '1', '1', '阅读理解', '86', '2025-11-15');
INSERT INTO `homework_score` VALUES ('411', '1', '1', '文言文', '82', '2025-11-15');
INSERT INTO `homework_score` VALUES ('412', '1', '1', '现代文阅读', '84', '2025-11-15');
INSERT INTO `homework_score` VALUES ('413', '1', '2', '阅读理解', '79', '2025-11-15');
INSERT INTO `homework_score` VALUES ('414', '1', '2', '文言文', '76', '2025-11-15');
INSERT INTO `homework_score` VALUES ('415', '1', '2', '现代文阅读', '81', '2025-11-15');
INSERT INTO `homework_score` VALUES ('416', '1', '3', '阅读理解', '82', '2025-11-15');
INSERT INTO `homework_score` VALUES ('417', '1', '3', '作文写作', '79', '2025-11-15');
INSERT INTO `homework_score` VALUES ('418', '1', '4', '阅读理解', '84', '2025-11-15');
INSERT INTO `homework_score` VALUES ('419', '1', '4', '文言文', '83', '2025-11-15');
INSERT INTO `homework_score` VALUES ('420', '1', '4', '现代文阅读', '85', '2025-11-15');
INSERT INTO `homework_score` VALUES ('421', '1', '5', '阅读理解', '80', '2025-11-15');
INSERT INTO `homework_score` VALUES ('422', '1', '5', '基础知识', '82', '2025-11-15');
INSERT INTO `homework_score` VALUES ('423', '1', '6', '阅读理解', '83', '2025-11-15');
INSERT INTO `homework_score` VALUES ('424', '1', '6', '文言文', '81', '2025-11-15');
INSERT INTO `homework_score` VALUES ('425', '1', '7', '阅读理解', '78', '2025-11-15');
INSERT INTO `homework_score` VALUES ('426', '1', '7', '现代文阅读', '80', '2025-11-15');
INSERT INTO `homework_score` VALUES ('427', '1', '8', '阅读理解', '81', '2025-11-15');
INSERT INTO `homework_score` VALUES ('428', '1', '8', '作文写作', '79', '2025-11-15');
INSERT INTO `homework_score` VALUES ('429', '1', '9', '阅读理解', '85', '2025-11-15');
INSERT INTO `homework_score` VALUES ('430', '1', '9', '文言文', '84', '2025-11-15');
INSERT INTO `homework_score` VALUES ('431', '1', '10', '阅读理解', '82', '2025-11-15');
INSERT INTO `homework_score` VALUES ('432', '1', '10', '基础知识', '80', '2025-11-15');
INSERT INTO `homework_score` VALUES ('433', '1', '1', '阅读理解', '85', '2025-11-14');
INSERT INTO `homework_score` VALUES ('434', '1', '1', '文言文', '81', '2025-11-14');
INSERT INTO `homework_score` VALUES ('435', '1', '1', '现代文阅读', '83', '2025-11-14');
INSERT INTO `homework_score` VALUES ('436', '1', '2', '阅读理解', '78', '2025-11-14');
INSERT INTO `homework_score` VALUES ('437', '1', '2', '文言文', '75', '2025-11-14');
INSERT INTO `homework_score` VALUES ('438', '1', '2', '现代文阅读', '80', '2025-11-14');
INSERT INTO `homework_score` VALUES ('439', '1', '3', '阅读理解', '81', '2025-11-14');
INSERT INTO `homework_score` VALUES ('440', '1', '3', '作文写作', '78', '2025-11-14');
INSERT INTO `homework_score` VALUES ('441', '1', '4', '阅读理解', '83', '2025-11-14');
INSERT INTO `homework_score` VALUES ('442', '1', '4', '文言文', '82', '2025-11-14');
INSERT INTO `homework_score` VALUES ('443', '1', '4', '现代文阅读', '84', '2025-11-14');
INSERT INTO `homework_score` VALUES ('444', '1', '5', '阅读理解', '79', '2025-11-14');
INSERT INTO `homework_score` VALUES ('445', '1', '5', '基础知识', '81', '2025-11-14');
INSERT INTO `homework_score` VALUES ('446', '1', '6', '阅读理解', '82', '2025-11-14');
INSERT INTO `homework_score` VALUES ('447', '1', '6', '文言文', '80', '2025-11-14');
INSERT INTO `homework_score` VALUES ('448', '1', '7', '阅读理解', '77', '2025-11-14');
INSERT INTO `homework_score` VALUES ('449', '1', '7', '现代文阅读', '79', '2025-11-14');
INSERT INTO `homework_score` VALUES ('450', '1', '8', '阅读理解', '80', '2025-11-14');
INSERT INTO `homework_score` VALUES ('451', '1', '8', '作文写作', '78', '2025-11-14');
INSERT INTO `homework_score` VALUES ('452', '1', '9', '阅读理解', '84', '2025-11-14');
INSERT INTO `homework_score` VALUES ('453', '1', '9', '文言文', '83', '2025-11-14');
INSERT INTO `homework_score` VALUES ('454', '1', '10', '阅读理解', '81', '2025-11-14');
INSERT INTO `homework_score` VALUES ('455', '1', '10', '基础知识', '79', '2025-11-14');

-- ----------------------------
-- Table structure for homework_score_seq
-- ----------------------------
DROP TABLE IF EXISTS `homework_score_seq`;
CREATE TABLE `homework_score_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of homework_score_seq
-- ----------------------------
INSERT INTO `homework_score_seq` VALUES ('1');

-- ----------------------------
-- Table structure for homework_seq
-- ----------------------------
DROP TABLE IF EXISTS `homework_seq`;
CREATE TABLE `homework_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of homework_seq
-- ----------------------------
INSERT INTO `homework_seq` VALUES ('1');

-- ----------------------------
-- Table structure for image_history
-- ----------------------------
DROP TABLE IF EXISTS `image_history`;
CREATE TABLE `image_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `prompt` text,
  `image_url` varchar(500) NOT NULL,
  `seed_image_url` varchar(500) DEFAULT NULL,
  `source` varchar(50) DEFAULT 'coze',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_image_user_id` (`user_id`),
  KEY `idx_image_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of image_history
-- ----------------------------

-- ----------------------------
-- Table structure for interaction_record
-- ----------------------------
DROP TABLE IF EXISTS `interaction_record`;
CREATE TABLE `interaction_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL COMMENT '任务ID',
  `student_id` bigint(20) NOT NULL COMMENT '学生ID',
  `student_name` varchar(100) DEFAULT NULL COMMENT '学生姓名（冗余字段）',
  `interaction_type` varchar(50) NOT NULL COMMENT '互动类型：quickAnswer / question / reward',
  `points_earned` int(11) NOT NULL DEFAULT '0' COMMENT '获得的积分',
  `interaction_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '互动时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_interaction_type` (`interaction_type`),
  KEY `idx_interaction_time` (`interaction_time`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8mb4 COMMENT='课堂互动记录表';

-- ----------------------------
-- Records of interaction_record
-- ----------------------------
INSERT INTO `interaction_record` VALUES ('1', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 06:24:40');
INSERT INTO `interaction_record` VALUES ('2', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 06:24:40');
INSERT INTO `interaction_record` VALUES ('3', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 06:29:40');
INSERT INTO `interaction_record` VALUES ('4', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 06:34:40');
INSERT INTO `interaction_record` VALUES ('5', '4', '1', '王同学', 'question', '3', '2025-11-20 06:39:40');
INSERT INTO `interaction_record` VALUES ('6', '4', '5', '张同学', 'question', '3', '2025-11-20 06:44:40');
INSERT INTO `interaction_record` VALUES ('7', '7', '6', '赵同学', 'reward', '10', '2025-11-20 06:49:40');
INSERT INTO `interaction_record` VALUES ('8', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 06:54:40');
INSERT INTO `interaction_record` VALUES ('9', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 06:59:40');
INSERT INTO `interaction_record` VALUES ('10', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 07:04:40');
INSERT INTO `interaction_record` VALUES ('11', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 07:09:40');
INSERT INTO `interaction_record` VALUES ('12', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 07:14:40');
INSERT INTO `interaction_record` VALUES ('13', '5', '1', '王同学', 'question', '4', '2025-11-20 07:19:40');
INSERT INTO `interaction_record` VALUES ('14', '5', '6', '赵同学', 'question', '4', '2025-11-20 07:24:40');
INSERT INTO `interaction_record` VALUES ('15', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 07:39:40');
INSERT INTO `interaction_record` VALUES ('16', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 07:44:40');
INSERT INTO `interaction_record` VALUES ('17', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 07:49:40');
INSERT INTO `interaction_record` VALUES ('18', '4', '4', '李同学', 'question', '3', '2025-11-20 07:54:40');
INSERT INTO `interaction_record` VALUES ('19', '4', '5', '张同学', 'question', '3', '2025-11-20 07:59:40');
INSERT INTO `interaction_record` VALUES ('20', '4', '6', '赵同学', 'question', '3', '2025-11-20 08:04:40');
INSERT INTO `interaction_record` VALUES ('21', '7', '1', '王同学', 'reward', '10', '2025-11-20 08:09:40');
INSERT INTO `interaction_record` VALUES ('22', '7', '2', '刘同学', 'reward', '10', '2025-11-20 08:14:40');
INSERT INTO `interaction_record` VALUES ('23', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 08:24:40');
INSERT INTO `interaction_record` VALUES ('24', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 08:29:40');
INSERT INTO `interaction_record` VALUES ('25', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 08:34:40');
INSERT INTO `interaction_record` VALUES ('26', '5', '1', '王同学', 'question', '4', '2025-11-20 08:39:40');
INSERT INTO `interaction_record` VALUES ('27', '5', '2', '刘同学', 'question', '4', '2025-11-20 08:44:40');
INSERT INTO `interaction_record` VALUES ('28', '5', '6', '赵同学', 'question', '4', '2025-11-20 08:49:40');
INSERT INTO `interaction_record` VALUES ('29', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 08:54:40');
INSERT INTO `interaction_record` VALUES ('30', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 08:59:40');
INSERT INTO `interaction_record` VALUES ('31', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 09:04:40');
INSERT INTO `interaction_record` VALUES ('32', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 09:09:40');
INSERT INTO `interaction_record` VALUES ('33', '4', '5', '张同学', 'question', '3', '2025-11-20 09:14:40');
INSERT INTO `interaction_record` VALUES ('34', '4', '6', '赵同学', 'question', '3', '2025-11-20 09:19:40');
INSERT INTO `interaction_record` VALUES ('35', '7', '1', '王同学', 'reward', '10', '2025-11-20 09:24:40');
INSERT INTO `interaction_record` VALUES ('36', '7', '4', '李同学', 'reward', '10', '2025-11-20 09:29:40');
INSERT INTO `interaction_record` VALUES ('37', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 09:39:40');
INSERT INTO `interaction_record` VALUES ('38', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 09:44:40');
INSERT INTO `interaction_record` VALUES ('39', '5', '4', '李同学', 'question', '4', '2025-11-20 09:49:40');
INSERT INTO `interaction_record` VALUES ('40', '5', '5', '张同学', 'question', '4', '2025-11-20 09:54:40');
INSERT INTO `interaction_record` VALUES ('41', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 10:09:40');
INSERT INTO `interaction_record` VALUES ('42', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 10:14:40');
INSERT INTO `interaction_record` VALUES ('43', '4', '4', '李同学', 'question', '3', '2025-11-20 10:19:40');
INSERT INTO `interaction_record` VALUES ('44', '7', '2', '刘同学', 'reward', '10', '2025-11-20 10:24:40');
INSERT INTO `interaction_record` VALUES ('45', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 07:24:40');
INSERT INTO `interaction_record` VALUES ('46', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 07:29:40');
INSERT INTO `interaction_record` VALUES ('47', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 07:34:40');
INSERT INTO `interaction_record` VALUES ('48', '10', '3', '陈同学', 'question', '4', '2025-11-20 07:39:40');
INSERT INTO `interaction_record` VALUES ('49', '10', '7', '孙同学', 'question', '4', '2025-11-20 07:44:40');
INSERT INTO `interaction_record` VALUES ('50', '11', '7', '孙同学', 'reward', '6', '2025-11-20 07:49:40');
INSERT INTO `interaction_record` VALUES ('51', '11', '8', '周同学', 'reward', '6', '2025-11-20 07:54:40');
INSERT INTO `interaction_record` VALUES ('52', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 07:24:40');
INSERT INTO `interaction_record` VALUES ('53', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 07:29:40');
INSERT INTO `interaction_record` VALUES ('54', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 07:34:40');
INSERT INTO `interaction_record` VALUES ('55', '13', '9', '吴同学', 'question', '5', '2025-11-20 07:39:40');
INSERT INTO `interaction_record` VALUES ('56', '13', '10', '郑同学', 'question', '5', '2025-11-20 07:44:40');
INSERT INTO `interaction_record` VALUES ('57', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 07:46:12');
INSERT INTO `interaction_record` VALUES ('58', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 07:46:12');
INSERT INTO `interaction_record` VALUES ('59', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 07:51:12');
INSERT INTO `interaction_record` VALUES ('60', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 07:56:12');
INSERT INTO `interaction_record` VALUES ('61', '4', '1', '王同学', 'question', '3', '2025-11-20 08:01:12');
INSERT INTO `interaction_record` VALUES ('62', '4', '5', '张同学', 'question', '3', '2025-11-20 08:06:12');
INSERT INTO `interaction_record` VALUES ('63', '7', '6', '赵同学', 'reward', '10', '2025-11-20 08:11:12');
INSERT INTO `interaction_record` VALUES ('64', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 08:16:12');
INSERT INTO `interaction_record` VALUES ('65', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 08:21:12');
INSERT INTO `interaction_record` VALUES ('66', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 08:26:12');
INSERT INTO `interaction_record` VALUES ('67', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 08:31:12');
INSERT INTO `interaction_record` VALUES ('68', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 08:36:12');
INSERT INTO `interaction_record` VALUES ('69', '5', '1', '王同学', 'question', '4', '2025-11-20 08:41:12');
INSERT INTO `interaction_record` VALUES ('70', '5', '6', '赵同学', 'question', '4', '2025-11-20 08:46:12');
INSERT INTO `interaction_record` VALUES ('71', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 09:01:12');
INSERT INTO `interaction_record` VALUES ('72', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 09:06:12');
INSERT INTO `interaction_record` VALUES ('73', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 09:11:12');
INSERT INTO `interaction_record` VALUES ('74', '4', '4', '李同学', 'question', '3', '2025-11-20 09:16:12');
INSERT INTO `interaction_record` VALUES ('75', '4', '5', '张同学', 'question', '3', '2025-11-20 09:21:12');
INSERT INTO `interaction_record` VALUES ('76', '4', '6', '赵同学', 'question', '3', '2025-11-20 09:26:12');
INSERT INTO `interaction_record` VALUES ('77', '7', '1', '王同学', 'reward', '10', '2025-11-20 09:31:12');
INSERT INTO `interaction_record` VALUES ('78', '7', '2', '刘同学', 'reward', '10', '2025-11-20 09:36:12');
INSERT INTO `interaction_record` VALUES ('79', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 09:46:12');
INSERT INTO `interaction_record` VALUES ('80', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 09:51:12');
INSERT INTO `interaction_record` VALUES ('81', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 09:56:12');
INSERT INTO `interaction_record` VALUES ('82', '5', '1', '王同学', 'question', '4', '2025-11-20 10:01:12');
INSERT INTO `interaction_record` VALUES ('83', '5', '2', '刘同学', 'question', '4', '2025-11-20 10:06:12');
INSERT INTO `interaction_record` VALUES ('84', '5', '6', '赵同学', 'question', '4', '2025-11-20 10:11:12');
INSERT INTO `interaction_record` VALUES ('85', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 10:16:12');
INSERT INTO `interaction_record` VALUES ('86', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 10:21:12');
INSERT INTO `interaction_record` VALUES ('87', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 10:26:12');
INSERT INTO `interaction_record` VALUES ('88', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 10:31:12');
INSERT INTO `interaction_record` VALUES ('89', '4', '5', '张同学', 'question', '3', '2025-11-20 10:36:12');
INSERT INTO `interaction_record` VALUES ('90', '4', '6', '赵同学', 'question', '3', '2025-11-20 10:41:12');
INSERT INTO `interaction_record` VALUES ('91', '7', '1', '王同学', 'reward', '10', '2025-11-20 10:46:12');
INSERT INTO `interaction_record` VALUES ('92', '7', '4', '李同学', 'reward', '10', '2025-11-20 10:51:12');
INSERT INTO `interaction_record` VALUES ('93', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 11:01:12');
INSERT INTO `interaction_record` VALUES ('94', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 11:06:12');
INSERT INTO `interaction_record` VALUES ('95', '5', '4', '李同学', 'question', '4', '2025-11-20 11:11:12');
INSERT INTO `interaction_record` VALUES ('96', '5', '5', '张同学', 'question', '4', '2025-11-20 11:16:12');
INSERT INTO `interaction_record` VALUES ('97', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 11:31:12');
INSERT INTO `interaction_record` VALUES ('98', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 11:36:12');
INSERT INTO `interaction_record` VALUES ('99', '4', '4', '李同学', 'question', '3', '2025-11-20 11:41:12');
INSERT INTO `interaction_record` VALUES ('100', '7', '2', '刘同学', 'reward', '10', '2025-11-20 11:46:12');
INSERT INTO `interaction_record` VALUES ('101', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 08:46:12');
INSERT INTO `interaction_record` VALUES ('102', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 08:51:12');
INSERT INTO `interaction_record` VALUES ('103', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 08:56:12');
INSERT INTO `interaction_record` VALUES ('104', '10', '3', '陈同学', 'question', '4', '2025-11-20 09:01:12');
INSERT INTO `interaction_record` VALUES ('105', '10', '7', '孙同学', 'question', '4', '2025-11-20 09:06:12');
INSERT INTO `interaction_record` VALUES ('106', '11', '7', '孙同学', 'reward', '6', '2025-11-20 09:11:12');
INSERT INTO `interaction_record` VALUES ('107', '11', '8', '周同学', 'reward', '6', '2025-11-20 09:16:12');
INSERT INTO `interaction_record` VALUES ('108', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 08:46:12');
INSERT INTO `interaction_record` VALUES ('109', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 08:51:12');
INSERT INTO `interaction_record` VALUES ('110', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 08:56:12');
INSERT INTO `interaction_record` VALUES ('111', '13', '9', '吴同学', 'question', '5', '2025-11-20 09:01:12');
INSERT INTO `interaction_record` VALUES ('112', '13', '10', '郑同学', 'question', '5', '2025-11-20 09:06:12');
INSERT INTO `interaction_record` VALUES ('113', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 07:50:11');
INSERT INTO `interaction_record` VALUES ('114', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 07:50:11');
INSERT INTO `interaction_record` VALUES ('115', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 07:55:11');
INSERT INTO `interaction_record` VALUES ('116', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 08:00:11');
INSERT INTO `interaction_record` VALUES ('117', '4', '1', '王同学', 'question', '3', '2025-11-20 08:05:11');
INSERT INTO `interaction_record` VALUES ('118', '4', '5', '张同学', 'question', '3', '2025-11-20 08:10:11');
INSERT INTO `interaction_record` VALUES ('119', '7', '6', '赵同学', 'reward', '10', '2025-11-20 08:15:11');
INSERT INTO `interaction_record` VALUES ('120', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 08:20:11');
INSERT INTO `interaction_record` VALUES ('121', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 08:25:11');
INSERT INTO `interaction_record` VALUES ('122', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 08:30:11');
INSERT INTO `interaction_record` VALUES ('123', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 08:35:11');
INSERT INTO `interaction_record` VALUES ('124', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 08:40:11');
INSERT INTO `interaction_record` VALUES ('125', '5', '1', '王同学', 'question', '4', '2025-11-20 08:45:11');
INSERT INTO `interaction_record` VALUES ('126', '5', '6', '赵同学', 'question', '4', '2025-11-20 08:50:11');
INSERT INTO `interaction_record` VALUES ('127', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 09:05:11');
INSERT INTO `interaction_record` VALUES ('128', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 09:10:11');
INSERT INTO `interaction_record` VALUES ('129', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 09:15:11');
INSERT INTO `interaction_record` VALUES ('130', '4', '4', '李同学', 'question', '3', '2025-11-20 09:20:11');
INSERT INTO `interaction_record` VALUES ('131', '4', '5', '张同学', 'question', '3', '2025-11-20 09:25:11');
INSERT INTO `interaction_record` VALUES ('132', '4', '6', '赵同学', 'question', '3', '2025-11-20 09:30:11');
INSERT INTO `interaction_record` VALUES ('133', '7', '1', '王同学', 'reward', '10', '2025-11-20 09:35:11');
INSERT INTO `interaction_record` VALUES ('134', '7', '2', '刘同学', 'reward', '10', '2025-11-20 09:40:11');
INSERT INTO `interaction_record` VALUES ('135', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 09:50:11');
INSERT INTO `interaction_record` VALUES ('136', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 09:55:11');
INSERT INTO `interaction_record` VALUES ('137', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 10:00:11');
INSERT INTO `interaction_record` VALUES ('138', '5', '1', '王同学', 'question', '4', '2025-11-20 10:05:11');
INSERT INTO `interaction_record` VALUES ('139', '5', '2', '刘同学', 'question', '4', '2025-11-20 10:10:11');
INSERT INTO `interaction_record` VALUES ('140', '5', '6', '赵同学', 'question', '4', '2025-11-20 10:15:11');
INSERT INTO `interaction_record` VALUES ('141', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 10:20:11');
INSERT INTO `interaction_record` VALUES ('142', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 10:25:11');
INSERT INTO `interaction_record` VALUES ('143', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 10:30:11');
INSERT INTO `interaction_record` VALUES ('144', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 10:35:11');
INSERT INTO `interaction_record` VALUES ('145', '4', '5', '张同学', 'question', '3', '2025-11-20 10:40:11');
INSERT INTO `interaction_record` VALUES ('146', '4', '6', '赵同学', 'question', '3', '2025-11-20 10:45:11');
INSERT INTO `interaction_record` VALUES ('147', '7', '1', '王同学', 'reward', '10', '2025-11-20 10:50:11');
INSERT INTO `interaction_record` VALUES ('148', '7', '4', '李同学', 'reward', '10', '2025-11-20 10:55:11');
INSERT INTO `interaction_record` VALUES ('149', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 11:05:11');
INSERT INTO `interaction_record` VALUES ('150', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 11:10:11');
INSERT INTO `interaction_record` VALUES ('151', '5', '4', '李同学', 'question', '4', '2025-11-20 11:15:11');
INSERT INTO `interaction_record` VALUES ('152', '5', '5', '张同学', 'question', '4', '2025-11-20 11:20:11');
INSERT INTO `interaction_record` VALUES ('153', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 11:35:11');
INSERT INTO `interaction_record` VALUES ('154', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 11:40:11');
INSERT INTO `interaction_record` VALUES ('155', '4', '4', '李同学', 'question', '3', '2025-11-20 11:45:11');
INSERT INTO `interaction_record` VALUES ('156', '7', '2', '刘同学', 'reward', '10', '2025-11-20 11:50:11');
INSERT INTO `interaction_record` VALUES ('157', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 08:50:11');
INSERT INTO `interaction_record` VALUES ('158', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 08:55:11');
INSERT INTO `interaction_record` VALUES ('159', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 09:00:11');
INSERT INTO `interaction_record` VALUES ('160', '10', '3', '陈同学', 'question', '4', '2025-11-20 09:05:11');
INSERT INTO `interaction_record` VALUES ('161', '10', '7', '孙同学', 'question', '4', '2025-11-20 09:10:11');
INSERT INTO `interaction_record` VALUES ('162', '11', '7', '孙同学', 'reward', '6', '2025-11-20 09:15:11');
INSERT INTO `interaction_record` VALUES ('163', '11', '8', '周同学', 'reward', '6', '2025-11-20 09:20:11');
INSERT INTO `interaction_record` VALUES ('164', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 08:50:11');
INSERT INTO `interaction_record` VALUES ('165', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 08:55:11');
INSERT INTO `interaction_record` VALUES ('166', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 09:00:11');
INSERT INTO `interaction_record` VALUES ('167', '13', '9', '吴同学', 'question', '5', '2025-11-20 09:05:11');
INSERT INTO `interaction_record` VALUES ('168', '13', '10', '郑同学', 'question', '5', '2025-11-20 09:10:11');
INSERT INTO `interaction_record` VALUES ('169', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 07:53:54');
INSERT INTO `interaction_record` VALUES ('170', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 07:53:54');
INSERT INTO `interaction_record` VALUES ('171', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 07:58:54');
INSERT INTO `interaction_record` VALUES ('172', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 08:03:54');
INSERT INTO `interaction_record` VALUES ('173', '4', '1', '王同学', 'question', '3', '2025-11-20 08:08:54');
INSERT INTO `interaction_record` VALUES ('174', '4', '5', '张同学', 'question', '3', '2025-11-20 08:13:54');
INSERT INTO `interaction_record` VALUES ('175', '7', '6', '赵同学', 'reward', '10', '2025-11-20 08:18:54');
INSERT INTO `interaction_record` VALUES ('176', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 08:23:54');
INSERT INTO `interaction_record` VALUES ('177', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 08:28:54');
INSERT INTO `interaction_record` VALUES ('178', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 08:33:54');
INSERT INTO `interaction_record` VALUES ('179', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 08:38:54');
INSERT INTO `interaction_record` VALUES ('180', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 08:43:54');
INSERT INTO `interaction_record` VALUES ('181', '5', '1', '王同学', 'question', '4', '2025-11-20 08:48:54');
INSERT INTO `interaction_record` VALUES ('182', '5', '6', '赵同学', 'question', '4', '2025-11-20 08:53:54');
INSERT INTO `interaction_record` VALUES ('183', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 09:08:54');
INSERT INTO `interaction_record` VALUES ('184', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 09:13:54');
INSERT INTO `interaction_record` VALUES ('185', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 09:18:54');
INSERT INTO `interaction_record` VALUES ('186', '4', '4', '李同学', 'question', '3', '2025-11-20 09:23:54');
INSERT INTO `interaction_record` VALUES ('187', '4', '5', '张同学', 'question', '3', '2025-11-20 09:28:54');
INSERT INTO `interaction_record` VALUES ('188', '4', '6', '赵同学', 'question', '3', '2025-11-20 09:33:54');
INSERT INTO `interaction_record` VALUES ('189', '7', '1', '王同学', 'reward', '10', '2025-11-20 09:38:54');
INSERT INTO `interaction_record` VALUES ('190', '7', '2', '刘同学', 'reward', '10', '2025-11-20 09:43:54');
INSERT INTO `interaction_record` VALUES ('191', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 09:53:54');
INSERT INTO `interaction_record` VALUES ('192', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 09:58:54');
INSERT INTO `interaction_record` VALUES ('193', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 10:03:54');
INSERT INTO `interaction_record` VALUES ('194', '5', '1', '王同学', 'question', '4', '2025-11-20 10:08:54');
INSERT INTO `interaction_record` VALUES ('195', '5', '2', '刘同学', 'question', '4', '2025-11-20 10:13:54');
INSERT INTO `interaction_record` VALUES ('196', '5', '6', '赵同学', 'question', '4', '2025-11-20 10:18:54');
INSERT INTO `interaction_record` VALUES ('197', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 10:23:54');
INSERT INTO `interaction_record` VALUES ('198', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 10:28:54');
INSERT INTO `interaction_record` VALUES ('199', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 10:33:54');
INSERT INTO `interaction_record` VALUES ('200', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 10:38:54');
INSERT INTO `interaction_record` VALUES ('201', '4', '5', '张同学', 'question', '3', '2025-11-20 10:43:54');
INSERT INTO `interaction_record` VALUES ('202', '4', '6', '赵同学', 'question', '3', '2025-11-20 10:48:54');
INSERT INTO `interaction_record` VALUES ('203', '7', '1', '王同学', 'reward', '10', '2025-11-20 10:53:54');
INSERT INTO `interaction_record` VALUES ('204', '7', '4', '李同学', 'reward', '10', '2025-11-20 10:58:54');
INSERT INTO `interaction_record` VALUES ('205', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 11:08:54');
INSERT INTO `interaction_record` VALUES ('206', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 11:13:54');
INSERT INTO `interaction_record` VALUES ('207', '5', '4', '李同学', 'question', '4', '2025-11-20 11:18:54');
INSERT INTO `interaction_record` VALUES ('208', '5', '5', '张同学', 'question', '4', '2025-11-20 11:23:54');
INSERT INTO `interaction_record` VALUES ('209', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 11:38:54');
INSERT INTO `interaction_record` VALUES ('210', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 11:43:54');
INSERT INTO `interaction_record` VALUES ('211', '4', '4', '李同学', 'question', '3', '2025-11-20 11:48:54');
INSERT INTO `interaction_record` VALUES ('212', '7', '2', '刘同学', 'reward', '10', '2025-11-20 11:53:54');
INSERT INTO `interaction_record` VALUES ('213', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 08:53:54');
INSERT INTO `interaction_record` VALUES ('214', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 08:58:54');
INSERT INTO `interaction_record` VALUES ('215', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 09:03:54');
INSERT INTO `interaction_record` VALUES ('216', '10', '3', '陈同学', 'question', '4', '2025-11-20 09:08:54');
INSERT INTO `interaction_record` VALUES ('217', '10', '7', '孙同学', 'question', '4', '2025-11-20 09:13:54');
INSERT INTO `interaction_record` VALUES ('218', '11', '7', '孙同学', 'reward', '6', '2025-11-20 09:18:54');
INSERT INTO `interaction_record` VALUES ('219', '11', '8', '周同学', 'reward', '6', '2025-11-20 09:23:54');
INSERT INTO `interaction_record` VALUES ('220', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 08:53:54');
INSERT INTO `interaction_record` VALUES ('221', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 08:58:54');
INSERT INTO `interaction_record` VALUES ('222', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 09:03:54');
INSERT INTO `interaction_record` VALUES ('223', '13', '9', '吴同学', 'question', '5', '2025-11-20 09:08:54');
INSERT INTO `interaction_record` VALUES ('224', '13', '10', '郑同学', 'question', '5', '2025-11-20 09:13:54');
INSERT INTO `interaction_record` VALUES ('225', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 13:13:55');
INSERT INTO `interaction_record` VALUES ('226', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 13:13:55');
INSERT INTO `interaction_record` VALUES ('227', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 13:18:55');
INSERT INTO `interaction_record` VALUES ('228', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 13:23:55');
INSERT INTO `interaction_record` VALUES ('229', '4', '1', '王同学', 'question', '3', '2025-11-20 13:28:55');
INSERT INTO `interaction_record` VALUES ('230', '4', '5', '张同学', 'question', '3', '2025-11-20 13:33:55');
INSERT INTO `interaction_record` VALUES ('231', '7', '6', '赵同学', 'reward', '10', '2025-11-20 13:38:55');
INSERT INTO `interaction_record` VALUES ('232', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 13:43:55');
INSERT INTO `interaction_record` VALUES ('233', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 13:48:55');
INSERT INTO `interaction_record` VALUES ('234', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 13:53:55');
INSERT INTO `interaction_record` VALUES ('235', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 13:58:55');
INSERT INTO `interaction_record` VALUES ('236', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 14:03:55');
INSERT INTO `interaction_record` VALUES ('237', '5', '1', '王同学', 'question', '4', '2025-11-20 14:08:55');
INSERT INTO `interaction_record` VALUES ('238', '5', '6', '赵同学', 'question', '4', '2025-11-20 14:13:55');
INSERT INTO `interaction_record` VALUES ('239', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 14:28:55');
INSERT INTO `interaction_record` VALUES ('240', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 14:33:55');
INSERT INTO `interaction_record` VALUES ('241', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 14:38:55');
INSERT INTO `interaction_record` VALUES ('242', '4', '4', '李同学', 'question', '3', '2025-11-20 14:43:55');
INSERT INTO `interaction_record` VALUES ('243', '4', '5', '张同学', 'question', '3', '2025-11-20 14:48:55');
INSERT INTO `interaction_record` VALUES ('244', '4', '6', '赵同学', 'question', '3', '2025-11-20 14:53:55');
INSERT INTO `interaction_record` VALUES ('245', '7', '1', '王同学', 'reward', '10', '2025-11-20 14:58:55');
INSERT INTO `interaction_record` VALUES ('246', '7', '2', '刘同学', 'reward', '10', '2025-11-20 15:03:55');
INSERT INTO `interaction_record` VALUES ('247', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 15:13:55');
INSERT INTO `interaction_record` VALUES ('248', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 15:18:55');
INSERT INTO `interaction_record` VALUES ('249', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 15:23:55');
INSERT INTO `interaction_record` VALUES ('250', '5', '1', '王同学', 'question', '4', '2025-11-20 15:28:55');
INSERT INTO `interaction_record` VALUES ('251', '5', '2', '刘同学', 'question', '4', '2025-11-20 15:33:55');
INSERT INTO `interaction_record` VALUES ('252', '5', '6', '赵同学', 'question', '4', '2025-11-20 15:38:55');
INSERT INTO `interaction_record` VALUES ('253', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 15:43:55');
INSERT INTO `interaction_record` VALUES ('254', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 15:48:55');
INSERT INTO `interaction_record` VALUES ('255', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 15:53:55');
INSERT INTO `interaction_record` VALUES ('256', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 15:58:55');
INSERT INTO `interaction_record` VALUES ('257', '4', '5', '张同学', 'question', '3', '2025-11-20 16:03:55');
INSERT INTO `interaction_record` VALUES ('258', '4', '6', '赵同学', 'question', '3', '2025-11-20 16:08:55');
INSERT INTO `interaction_record` VALUES ('259', '7', '1', '王同学', 'reward', '10', '2025-11-20 16:13:55');
INSERT INTO `interaction_record` VALUES ('260', '7', '4', '李同学', 'reward', '10', '2025-11-20 16:18:55');
INSERT INTO `interaction_record` VALUES ('261', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 16:28:55');
INSERT INTO `interaction_record` VALUES ('262', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 16:33:55');
INSERT INTO `interaction_record` VALUES ('263', '5', '4', '李同学', 'question', '4', '2025-11-20 16:38:55');
INSERT INTO `interaction_record` VALUES ('264', '5', '5', '张同学', 'question', '4', '2025-11-20 16:43:55');
INSERT INTO `interaction_record` VALUES ('265', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 16:58:55');
INSERT INTO `interaction_record` VALUES ('266', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 17:03:55');
INSERT INTO `interaction_record` VALUES ('267', '4', '4', '李同学', 'question', '3', '2025-11-20 17:08:55');
INSERT INTO `interaction_record` VALUES ('268', '7', '2', '刘同学', 'reward', '10', '2025-11-20 17:13:55');
INSERT INTO `interaction_record` VALUES ('269', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 14:13:55');
INSERT INTO `interaction_record` VALUES ('270', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 14:18:55');
INSERT INTO `interaction_record` VALUES ('271', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 14:23:55');
INSERT INTO `interaction_record` VALUES ('272', '10', '3', '陈同学', 'question', '4', '2025-11-20 14:28:55');
INSERT INTO `interaction_record` VALUES ('273', '10', '7', '孙同学', 'question', '4', '2025-11-20 14:33:55');
INSERT INTO `interaction_record` VALUES ('274', '11', '7', '孙同学', 'reward', '6', '2025-11-20 14:38:55');
INSERT INTO `interaction_record` VALUES ('275', '11', '8', '周同学', 'reward', '6', '2025-11-20 14:43:55');
INSERT INTO `interaction_record` VALUES ('276', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 14:13:55');
INSERT INTO `interaction_record` VALUES ('277', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 14:18:55');
INSERT INTO `interaction_record` VALUES ('278', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 14:23:55');
INSERT INTO `interaction_record` VALUES ('279', '13', '9', '吴同学', 'question', '5', '2025-11-20 14:28:55');
INSERT INTO `interaction_record` VALUES ('280', '13', '10', '郑同学', 'question', '5', '2025-11-20 14:33:55');
INSERT INTO `interaction_record` VALUES ('281', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 13:53:44');
INSERT INTO `interaction_record` VALUES ('282', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 13:53:44');
INSERT INTO `interaction_record` VALUES ('283', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 13:58:44');
INSERT INTO `interaction_record` VALUES ('284', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 14:03:44');
INSERT INTO `interaction_record` VALUES ('285', '4', '1', '王同学', 'question', '3', '2025-11-20 14:08:44');
INSERT INTO `interaction_record` VALUES ('286', '4', '5', '张同学', 'question', '3', '2025-11-20 14:13:44');
INSERT INTO `interaction_record` VALUES ('287', '7', '6', '赵同学', 'reward', '10', '2025-11-20 14:18:44');
INSERT INTO `interaction_record` VALUES ('288', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 14:23:44');
INSERT INTO `interaction_record` VALUES ('289', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 14:28:44');
INSERT INTO `interaction_record` VALUES ('290', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 14:33:44');
INSERT INTO `interaction_record` VALUES ('291', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 14:38:44');
INSERT INTO `interaction_record` VALUES ('292', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 14:43:44');
INSERT INTO `interaction_record` VALUES ('293', '5', '1', '王同学', 'question', '4', '2025-11-20 14:48:44');
INSERT INTO `interaction_record` VALUES ('294', '5', '6', '赵同学', 'question', '4', '2025-11-20 14:53:44');
INSERT INTO `interaction_record` VALUES ('295', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 15:08:44');
INSERT INTO `interaction_record` VALUES ('296', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 15:13:44');
INSERT INTO `interaction_record` VALUES ('297', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 15:18:44');
INSERT INTO `interaction_record` VALUES ('298', '4', '4', '李同学', 'question', '3', '2025-11-20 15:23:44');
INSERT INTO `interaction_record` VALUES ('299', '4', '5', '张同学', 'question', '3', '2025-11-20 15:28:44');
INSERT INTO `interaction_record` VALUES ('300', '4', '6', '赵同学', 'question', '3', '2025-11-20 15:33:44');
INSERT INTO `interaction_record` VALUES ('301', '7', '1', '王同学', 'reward', '10', '2025-11-20 15:38:44');
INSERT INTO `interaction_record` VALUES ('302', '7', '2', '刘同学', 'reward', '10', '2025-11-20 15:43:44');
INSERT INTO `interaction_record` VALUES ('303', '2', '4', '李同学', 'quickAnswer', '8', '2025-11-20 15:53:44');
INSERT INTO `interaction_record` VALUES ('304', '2', '5', '张同学', 'quickAnswer', '8', '2025-11-20 15:58:44');
INSERT INTO `interaction_record` VALUES ('305', '2', '6', '赵同学', 'quickAnswer', '8', '2025-11-20 16:03:44');
INSERT INTO `interaction_record` VALUES ('306', '5', '1', '王同学', 'question', '4', '2025-11-20 16:08:44');
INSERT INTO `interaction_record` VALUES ('307', '5', '2', '刘同学', 'question', '4', '2025-11-20 16:13:44');
INSERT INTO `interaction_record` VALUES ('308', '5', '6', '赵同学', 'question', '4', '2025-11-20 16:18:44');
INSERT INTO `interaction_record` VALUES ('309', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 16:23:44');
INSERT INTO `interaction_record` VALUES ('310', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 16:28:44');
INSERT INTO `interaction_record` VALUES ('311', '1', '4', '李同学', 'quickAnswer', '5', '2025-11-20 16:33:44');
INSERT INTO `interaction_record` VALUES ('312', '1', '5', '张同学', 'quickAnswer', '5', '2025-11-20 16:38:44');
INSERT INTO `interaction_record` VALUES ('313', '4', '5', '张同学', 'question', '3', '2025-11-20 16:43:44');
INSERT INTO `interaction_record` VALUES ('314', '4', '6', '赵同学', 'question', '3', '2025-11-20 16:48:44');
INSERT INTO `interaction_record` VALUES ('315', '7', '1', '王同学', 'reward', '10', '2025-11-20 16:53:44');
INSERT INTO `interaction_record` VALUES ('316', '7', '4', '李同学', 'reward', '10', '2025-11-20 16:58:44');
INSERT INTO `interaction_record` VALUES ('317', '2', '1', '王同学', 'quickAnswer', '8', '2025-11-20 17:08:44');
INSERT INTO `interaction_record` VALUES ('318', '2', '2', '刘同学', 'quickAnswer', '8', '2025-11-20 17:13:44');
INSERT INTO `interaction_record` VALUES ('319', '5', '4', '李同学', 'question', '4', '2025-11-20 17:18:44');
INSERT INTO `interaction_record` VALUES ('320', '5', '5', '张同学', 'question', '4', '2025-11-20 17:23:44');
INSERT INTO `interaction_record` VALUES ('321', '1', '1', '王同学', 'quickAnswer', '5', '2025-11-20 17:38:44');
INSERT INTO `interaction_record` VALUES ('322', '1', '2', '刘同学', 'quickAnswer', '5', '2025-11-20 17:43:44');
INSERT INTO `interaction_record` VALUES ('323', '4', '4', '李同学', 'question', '3', '2025-11-20 17:48:44');
INSERT INTO `interaction_record` VALUES ('324', '7', '2', '刘同学', 'reward', '10', '2025-11-20 17:53:44');
INSERT INTO `interaction_record` VALUES ('325', '9', '3', '陈同学', 'quickAnswer', '5', '2025-11-20 14:53:44');
INSERT INTO `interaction_record` VALUES ('326', '9', '7', '孙同学', 'quickAnswer', '5', '2025-11-20 14:58:44');
INSERT INTO `interaction_record` VALUES ('327', '9', '8', '周同学', 'quickAnswer', '5', '2025-11-20 15:03:44');
INSERT INTO `interaction_record` VALUES ('328', '10', '3', '陈同学', 'question', '4', '2025-11-20 15:08:44');
INSERT INTO `interaction_record` VALUES ('329', '10', '7', '孙同学', 'question', '4', '2025-11-20 15:13:44');
INSERT INTO `interaction_record` VALUES ('330', '11', '7', '孙同学', 'reward', '6', '2025-11-20 15:18:44');
INSERT INTO `interaction_record` VALUES ('331', '11', '8', '周同学', 'reward', '6', '2025-11-20 15:23:44');
INSERT INTO `interaction_record` VALUES ('332', '12', '9', '吴同学', 'quickAnswer', '6', '2025-11-20 14:53:44');
INSERT INTO `interaction_record` VALUES ('333', '12', '10', '郑同学', 'quickAnswer', '6', '2025-11-20 14:58:44');
INSERT INTO `interaction_record` VALUES ('334', '12', '11', '马同学', 'quickAnswer', '6', '2025-11-20 15:03:44');
INSERT INTO `interaction_record` VALUES ('335', '13', '9', '吴同学', 'question', '5', '2025-11-20 15:08:44');
INSERT INTO `interaction_record` VALUES ('336', '13', '10', '郑同学', 'question', '5', '2025-11-20 15:13:44');

-- ----------------------------
-- Table structure for interaction_task
-- ----------------------------
DROP TABLE IF EXISTS `interaction_task`;
CREATE TABLE `interaction_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `clazz_id` bigint(20) NOT NULL COMMENT '班级ID',
  `teacher_id` bigint(20) DEFAULT NULL COMMENT '教师ID',
  `type` varchar(50) NOT NULL COMMENT '互动类型：quickAnswer（抢答）/ question（提问）/ reward（积分奖励）',
  `title` varchar(255) NOT NULL COMMENT '任务标题',
  `points` int(11) NOT NULL DEFAULT '0' COMMENT '奖励积分',
  `duration` int(11) DEFAULT NULL COMMENT '抢答时长（秒）',
  `question` text COMMENT '提问内容',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否激活',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_clazz_id` (`clazz_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COMMENT='课堂互动任务表';

-- ----------------------------
-- Records of interaction_task
-- ----------------------------
INSERT INTO `interaction_task` VALUES ('1', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 09:20:25');
INSERT INTO `interaction_task` VALUES ('2', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 10:20:25');
INSERT INTO `interaction_task` VALUES ('3', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 11:20:25');
INSERT INTO `interaction_task` VALUES ('4', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 09:50:25');
INSERT INTO `interaction_task` VALUES ('5', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 10:50:25');
INSERT INTO `interaction_task` VALUES ('6', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 11:20:25');
INSERT INTO `interaction_task` VALUES ('7', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 10:20:25');
INSERT INTO `interaction_task` VALUES ('8', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 11:20:25');
INSERT INTO `interaction_task` VALUES ('9', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 10:20:25');
INSERT INTO `interaction_task` VALUES ('10', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 10:35:25');
INSERT INTO `interaction_task` VALUES ('11', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 10:50:25');
INSERT INTO `interaction_task` VALUES ('12', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 09:20:25');
INSERT INTO `interaction_task` VALUES ('13', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 10:20:25');
INSERT INTO `interaction_task` VALUES ('14', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 11:20:25');
INSERT INTO `interaction_task` VALUES ('15', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 09:24:40');
INSERT INTO `interaction_task` VALUES ('16', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 10:24:40');
INSERT INTO `interaction_task` VALUES ('17', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 11:24:40');
INSERT INTO `interaction_task` VALUES ('18', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 09:54:40');
INSERT INTO `interaction_task` VALUES ('19', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 10:54:40');
INSERT INTO `interaction_task` VALUES ('20', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 11:24:40');
INSERT INTO `interaction_task` VALUES ('21', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 10:24:40');
INSERT INTO `interaction_task` VALUES ('22', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 11:24:40');
INSERT INTO `interaction_task` VALUES ('23', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 10:24:40');
INSERT INTO `interaction_task` VALUES ('24', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 10:39:40');
INSERT INTO `interaction_task` VALUES ('25', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 10:54:40');
INSERT INTO `interaction_task` VALUES ('26', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 09:24:40');
INSERT INTO `interaction_task` VALUES ('27', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 10:24:40');
INSERT INTO `interaction_task` VALUES ('28', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 11:24:40');
INSERT INTO `interaction_task` VALUES ('29', '1', '1', 'quickAnswer', '观沧海的情感', '5', '30', null, '0', '2025-11-20 03:29:22');
INSERT INTO `interaction_task` VALUES ('30', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 10:46:12');
INSERT INTO `interaction_task` VALUES ('31', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 11:46:12');
INSERT INTO `interaction_task` VALUES ('32', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 12:46:12');
INSERT INTO `interaction_task` VALUES ('33', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 11:16:12');
INSERT INTO `interaction_task` VALUES ('34', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 12:16:12');
INSERT INTO `interaction_task` VALUES ('35', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 12:46:12');
INSERT INTO `interaction_task` VALUES ('36', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 11:46:12');
INSERT INTO `interaction_task` VALUES ('37', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 12:46:12');
INSERT INTO `interaction_task` VALUES ('38', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 11:46:12');
INSERT INTO `interaction_task` VALUES ('39', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 12:01:12');
INSERT INTO `interaction_task` VALUES ('40', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 12:16:12');
INSERT INTO `interaction_task` VALUES ('41', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 10:46:12');
INSERT INTO `interaction_task` VALUES ('42', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 11:46:12');
INSERT INTO `interaction_task` VALUES ('43', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 12:46:12');
INSERT INTO `interaction_task` VALUES ('44', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 10:50:11');
INSERT INTO `interaction_task` VALUES ('45', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 11:50:11');
INSERT INTO `interaction_task` VALUES ('46', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 12:50:11');
INSERT INTO `interaction_task` VALUES ('47', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 11:20:11');
INSERT INTO `interaction_task` VALUES ('48', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 12:20:11');
INSERT INTO `interaction_task` VALUES ('49', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 12:50:11');
INSERT INTO `interaction_task` VALUES ('50', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 11:50:11');
INSERT INTO `interaction_task` VALUES ('51', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 12:50:11');
INSERT INTO `interaction_task` VALUES ('52', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 11:50:11');
INSERT INTO `interaction_task` VALUES ('53', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 12:05:11');
INSERT INTO `interaction_task` VALUES ('54', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 12:20:11');
INSERT INTO `interaction_task` VALUES ('55', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 10:50:11');
INSERT INTO `interaction_task` VALUES ('56', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 11:50:11');
INSERT INTO `interaction_task` VALUES ('57', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 12:50:11');
INSERT INTO `interaction_task` VALUES ('58', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 10:53:54');
INSERT INTO `interaction_task` VALUES ('59', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 11:53:54');
INSERT INTO `interaction_task` VALUES ('60', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 12:53:54');
INSERT INTO `interaction_task` VALUES ('61', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 11:23:54');
INSERT INTO `interaction_task` VALUES ('62', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 12:23:54');
INSERT INTO `interaction_task` VALUES ('63', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 12:53:54');
INSERT INTO `interaction_task` VALUES ('64', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 11:53:54');
INSERT INTO `interaction_task` VALUES ('65', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 12:53:54');
INSERT INTO `interaction_task` VALUES ('66', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 11:53:54');
INSERT INTO `interaction_task` VALUES ('67', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 12:08:54');
INSERT INTO `interaction_task` VALUES ('68', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 12:23:54');
INSERT INTO `interaction_task` VALUES ('69', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 10:53:54');
INSERT INTO `interaction_task` VALUES ('70', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 11:53:54');
INSERT INTO `interaction_task` VALUES ('71', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 12:53:54');
INSERT INTO `interaction_task` VALUES ('72', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 16:13:55');
INSERT INTO `interaction_task` VALUES ('73', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 17:13:55');
INSERT INTO `interaction_task` VALUES ('74', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 18:13:55');
INSERT INTO `interaction_task` VALUES ('75', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 16:43:55');
INSERT INTO `interaction_task` VALUES ('76', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 17:43:55');
INSERT INTO `interaction_task` VALUES ('77', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 18:13:55');
INSERT INTO `interaction_task` VALUES ('78', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 17:13:55');
INSERT INTO `interaction_task` VALUES ('79', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 18:13:55');
INSERT INTO `interaction_task` VALUES ('80', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 17:13:55');
INSERT INTO `interaction_task` VALUES ('81', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 17:28:55');
INSERT INTO `interaction_task` VALUES ('82', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 17:43:55');
INSERT INTO `interaction_task` VALUES ('83', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 16:13:55');
INSERT INTO `interaction_task` VALUES ('84', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 17:13:55');
INSERT INTO `interaction_task` VALUES ('85', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 18:13:55');
INSERT INTO `interaction_task` VALUES ('86', '1', '1', 'quickAnswer', '互动1', '5', '30', null, '0', '2025-11-20 10:34:47');
INSERT INTO `interaction_task` VALUES ('87', '1', '1', 'quickAnswer', '互动2', '5', '30', null, '0', '2025-11-20 10:35:00');
INSERT INTO `interaction_task` VALUES ('88', '1', '1', 'quickAnswer', '古诗词抢答', '5', '30', null, '1', '2025-11-20 16:53:44');
INSERT INTO `interaction_task` VALUES ('89', '1', '1', 'quickAnswer', '文言文实词抢答', '8', '45', null, '1', '2025-11-20 17:53:44');
INSERT INTO `interaction_task` VALUES ('90', '1', '1', 'quickAnswer', '现代文阅读抢答', '6', '30', null, '0', '2025-11-17 18:53:44');
INSERT INTO `interaction_task` VALUES ('91', '1', '1', 'question', '《春》的主旨理解', '3', null, '请分析《春》这篇文章表达了作者怎样的思想感情？', '1', '2025-11-20 17:23:44');
INSERT INTO `interaction_task` VALUES ('92', '1', '1', 'question', '文言文\"之\"字用法', '4', null, '请举例说明文言文中\"之\"字的几种常见用法。', '1', '2025-11-20 18:23:44');
INSERT INTO `interaction_task` VALUES ('93', '1', '1', 'question', '作文写作技巧', '5', null, '写记叙文时，如何通过细节描写表达情感？', '0', '2025-11-19 18:53:44');
INSERT INTO `interaction_task` VALUES ('94', '1', '1', 'reward', '课堂表现优秀奖励', '10', null, null, '1', '2025-11-20 17:53:44');
INSERT INTO `interaction_task` VALUES ('95', '1', '1', 'reward', '作业完成优秀奖励', '8', null, null, '0', '2025-11-18 18:53:44');
INSERT INTO `interaction_task` VALUES ('96', '2', '1', 'quickAnswer', '成语接龙抢答', '5', '30', null, '1', '2025-11-20 17:53:44');
INSERT INTO `interaction_task` VALUES ('97', '2', '1', 'question', '阅读理解技巧', '4', null, '如何快速找到文章的主旨？', '1', '2025-11-20 18:08:44');
INSERT INTO `interaction_task` VALUES ('98', '2', '1', 'reward', '积极参与奖励', '6', null, null, '1', '2025-11-20 18:23:44');
INSERT INTO `interaction_task` VALUES ('99', '3', '2', 'quickAnswer', '分数运算抢答', '6', '40', null, '1', '2025-11-20 16:53:44');
INSERT INTO `interaction_task` VALUES ('100', '3', '2', 'question', '分数加减法', '5', null, '计算 1/3 + 1/4 = ?', '1', '2025-11-20 17:53:44');
INSERT INTO `interaction_task` VALUES ('101', '3', '2', 'reward', '数学思维活跃奖励', '10', null, null, '0', '2025-11-19 18:53:44');

-- ----------------------------
-- Table structure for lesson_plan
-- ----------------------------
DROP TABLE IF EXISTS `lesson_plan`;
CREATE TABLE `lesson_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `stage` varchar(100) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `content` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `lesson_plan_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lesson_plan
-- ----------------------------

-- ----------------------------
-- Table structure for lesson_plan_collaborator
-- ----------------------------
DROP TABLE IF EXISTS `lesson_plan_collaborator`;
CREATE TABLE `lesson_plan_collaborator` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lesson_plan_id` bigint(20) NOT NULL,
  `teacher_id` bigint(20) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'editor',
  `status` varchar(20) DEFAULT 'offline',
  `joined_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `invite_code` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lesson_plan_id` (`lesson_plan_id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `lesson_plan_collaborator_ibfk_1` FOREIGN KEY (`lesson_plan_id`) REFERENCES `lesson_plan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_plan_collaborator_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lesson_plan_collaborator
-- ----------------------------

-- ----------------------------
-- Table structure for lesson_plan_history
-- ----------------------------
DROP TABLE IF EXISTS `lesson_plan_history`;
CREATE TABLE `lesson_plan_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lesson_plan_id` bigint(20) DEFAULT NULL,
  `course_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `stage` varchar(100) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `usage_snapshot` text,
  `content_snapshot` longtext,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `share_token` varchar(64) DEFAULT NULL,
  `share_expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lesson_plan_id` (`lesson_plan_id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_share_token` (`share_token`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `lesson_plan_history_ibfk_1` FOREIGN KEY (`lesson_plan_id`) REFERENCES `lesson_plan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_plan_history_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lesson_plan_history
-- ----------------------------

-- ----------------------------
-- Table structure for lesson_plan_seq
-- ----------------------------
DROP TABLE IF EXISTS `lesson_plan_seq`;
CREATE TABLE `lesson_plan_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lesson_plan_seq
-- ----------------------------
INSERT INTO `lesson_plan_seq` VALUES ('1');

-- ----------------------------
-- Table structure for lesson_plan_task
-- ----------------------------
DROP TABLE IF EXISTS `lesson_plan_task`;
CREATE TABLE `lesson_plan_task` (
  `task_id` varchar(255) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `result` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lesson_plan_task
-- ----------------------------

-- ----------------------------
-- Table structure for paper
-- ----------------------------
DROP TABLE IF EXISTS `paper`;
CREATE TABLE `paper` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) DEFAULT NULL COMMENT '课程ID',
  `clazz_id` bigint(20) DEFAULT NULL COMMENT '班级ID',
  `student_id` varchar(100) DEFAULT NULL COMMENT '学生ID',
  `student_name` varchar(100) DEFAULT NULL COMMENT '学生姓名',
  `paper_name` varchar(255) DEFAULT NULL COMMENT '试卷名称',
  `image_url` varchar(500) DEFAULT NULL COMMENT '试卷图片URL',
  `recognized_text` longtext COMMENT 'OCR识别的文本内容',
  `ocr_confidence` double DEFAULT NULL COMMENT 'OCR识别置信度（0-100）',
  `total_score` int(11) DEFAULT NULL COMMENT '总分',
  `student_score` int(11) DEFAULT NULL COMMENT '学生得分',
  `status` varchar(50) DEFAULT 'processing' COMMENT '状态：processing/completed/error',
  `processing_time` int(11) DEFAULT NULL COMMENT '处理时间（秒）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_clazz_id` (`clazz_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='试卷表';

-- ----------------------------
-- Records of paper
-- ----------------------------
INSERT INTO `paper` VALUES ('1', '1', '1', null, null, '数学', '/uploads/papers/1763637284087_数学.png', '第1题：“两个三角形面积相等”是“两个三角形全等”的(C)；第2题：设x∈R，则“0<x<3”是“|x-1|<2”的(C)；第3题：设x，y∈R，则“|x|≤1且|y|≤1”是“x²+y²≤2”的(D)；第4题：已知a，b∈R，则“0≤a≤1且0≤b≤1”是“0≤ab≤1”的(C)；第5题：“a>b>0”是“a²+a>b²+b”的(B)；第6题：“(2x-1)x=0”是“x=0”的充分不必要条件；第7题：设集合A={x|x≤1}，B={x|x≥a}，则“A B=R”是“a=1”的充分条件。', '95', '7', '7', 'completed', '20', '2025-11-20 11:14:44', '2025-11-20 11:15:04');

-- ----------------------------
-- Table structure for paper_answer
-- ----------------------------
DROP TABLE IF EXISTS `paper_answer`;
CREATE TABLE `paper_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `paper_id` bigint(20) NOT NULL COMMENT '试卷ID',
  `question_number` varchar(50) DEFAULT NULL COMMENT '题号',
  `question_type` varchar(50) DEFAULT NULL COMMENT '题型',
  `student_answer` text COMMENT '学生答案',
  `correct_answer` text COMMENT '正确答案',
  `score` int(11) DEFAULT NULL COMMENT '得分',
  `max_score` int(11) DEFAULT NULL COMMENT '满分',
  `scoring_points` text COMMENT '评分要点（JSON数组）',
  `error_type` varchar(100) DEFAULT NULL COMMENT '错误类型',
  `ai_analysis` text COMMENT 'AI分析内容',
  `suggestions` text COMMENT '改进建议（JSON数组）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_paper_id` (`paper_id`),
  KEY `idx_error_type` (`error_type`),
  CONSTRAINT `paper_answer_ibfk_1` FOREIGN KEY (`paper_id`) REFERENCES `paper` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='试卷答案表';

-- ----------------------------
-- Records of paper_answer
-- ----------------------------
INSERT INTO `paper_answer` VALUES ('1', '1', '第1题', '逻辑推理', 'C', 'C', '1', '1', '[\"判断两个命题间的逻辑关系\"]', '无错误', '学生正确识别了\'两个三角形面积相等\'是\'两个三角形全等\'的必要不充分条件', '[\"继续巩固充分必要条件的概念理解\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('2', '1', '第2题', '逻辑推理', 'C', 'C', '1', '1', '[\"判断不等式间的逻辑关系\"]', '无错误', '学生正确判断了\'0<x<3\'是\'|x-1|<2\'的充分必要条件', '[\"建议练习更多绝对值不等式的题目\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('3', '1', '第3题', '逻辑推理', 'D', 'D', '1', '1', '[\"判断多元不等式间的逻辑关系\"]', '无错误', '学生正确识别了\'|x|≤1且|y|≤1\'是\'x²+y²≤2\'的充分不必要条件', '[\"建议通过几何图形理解多元不等式的关系\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('4', '1', '第4题', '逻辑推理', 'C', 'C', '1', '1', '[\"判断乘积不等式与单个不等式的关系\"]', '无错误', '学生正确判断了\'0≤a≤1且0≤b≤1\'是\'0≤ab≤1\'的充分不必要条件', '[\"建议思考反例：当ab在0到1之间时，a和b不一定都在0到1之间\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('5', '1', '第5题', '逻辑推理', 'B', 'B', '1', '1', '[\"判断不等式变形后的逻辑关系\"]', '无错误', '学生正确识别了\'a>b>0\'是\'a²+a>b²+b\'的充分不必要条件', '[\"建议通过代数推导验证结论的正确性\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('6', '1', '第6题', '逻辑推理', '充分不必要条件', '充分不必要条件', '1', '1', '[\"判断方程解集的逻辑关系\"]', '无错误', '学生正确判断了\'(2x-1)x=0\'是\'x=0\'的充分不必要条件', '[\"注意方程(2x-1)x=0的解集为{0, 1/2}，确实充分但不必要\"]', '2025-11-20 11:15:04');
INSERT INTO `paper_answer` VALUES ('7', '1', '第7题', '逻辑推理', '充分条件', '充分条件', '1', '1', '[\"判断集合运算与特定值的逻辑关系\"]', '无错误', '学生正确判断了\'A B=R\'是\'a=1\'的充分条件', '[\"建议思考：当a=1时，A∪B确实等于R；但当A∪B=R时，a不一定等于1\"]', '2025-11-20 11:15:04');

-- ----------------------------
-- Table structure for ppt_history
-- ----------------------------
DROP TABLE IF EXISTS `ppt_history`;
CREATE TABLE `ppt_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `ppt_url` varchar(500) NOT NULL,
  `source` varchar(50) DEFAULT 'xf',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ppt_user_id` (`user_id`),
  KEY `idx_ppt_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ppt_history
-- ----------------------------

-- ----------------------------
-- Table structure for qa_message
-- ----------------------------
DROP TABLE IF EXISTS `qa_message`;
CREATE TABLE `qa_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `clazz_id` bigint(20) NOT NULL COMMENT '班级ID',
  `student_id` bigint(20) NOT NULL COMMENT '学生ID',
  `student_name` varchar(100) DEFAULT NULL COMMENT '学生姓名（冗余字段，便于查询）',
  `question` text NOT NULL COMMENT '学生问题',
  `answer` text COMMENT '老师回答（可选）',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '回答状态：pending（待回答）/ answered（已回答）',
  `is_urgent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否紧急',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `answered_at` datetime DEFAULT NULL COMMENT '回答时间',
  `teacher_id` bigint(20) DEFAULT NULL COMMENT '回答的老师ID（可选）',
  PRIMARY KEY (`id`),
  KEY `idx_clazz_id` (`clazz_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=utf8mb4 COMMENT='实时问答消息表';

-- ----------------------------
-- Records of qa_message
-- ----------------------------
INSERT INTO `qa_message` VALUES ('1', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-19 22:18:23', '2025-11-19 22:28:23', '1');
INSERT INTO `qa_message` VALUES ('2', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-19 21:18:23', '2025-11-19 21:48:23', '1');
INSERT INTO `qa_message` VALUES ('3', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 00:18:23', '2025-11-19 01:18:23', '1');
INSERT INTO `qa_message` VALUES ('4', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 00:18:23', '2025-11-18 04:18:23', '1');
INSERT INTO `qa_message` VALUES ('5', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 00:18:23', '2025-11-17 06:18:23', '1');
INSERT INTO `qa_message` VALUES ('6', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-19 23:48:23', null, null);
INSERT INTO `qa_message` VALUES ('7', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 00:03:23', null, null);
INSERT INTO `qa_message` VALUES ('8', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-19 23:18:23', null, null);
INSERT INTO `qa_message` VALUES ('9', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-19 23:33:23', null, null);
INSERT INTO `qa_message` VALUES ('10', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-19 20:18:23', '2025-11-19 20:48:23', '1');
INSERT INTO `qa_message` VALUES ('11', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 00:18:23', '2025-11-19 02:18:23', '1');
INSERT INTO `qa_message` VALUES ('12', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-19 23:58:23', null, null);
INSERT INTO `qa_message` VALUES ('13', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-19 22:48:23', null, null);
INSERT INTO `qa_message` VALUES ('14', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-19 19:18:23', '2025-11-19 19:58:23', '1');
INSERT INTO `qa_message` VALUES ('15', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-19 18:18:23', '2025-11-19 18:48:23', '1');
INSERT INTO `qa_message` VALUES ('16', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 00:08:23', null, null);
INSERT INTO `qa_message` VALUES ('17', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-19 22:18:23', null, null);
INSERT INTO `qa_message` VALUES ('18', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-19 17:18:23', '2025-11-19 18:03:23', '2');
INSERT INTO `qa_message` VALUES ('19', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-19 23:53:23', null, null);
INSERT INTO `qa_message` VALUES ('20', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-19 23:10:32', '2025-11-19 23:20:32', '1');
INSERT INTO `qa_message` VALUES ('21', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-19 22:10:32', '2025-11-19 22:40:32', '1');
INSERT INTO `qa_message` VALUES ('22', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 01:10:32', '2025-11-19 02:10:32', '1');
INSERT INTO `qa_message` VALUES ('23', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 01:10:32', '2025-11-18 05:10:32', '1');
INSERT INTO `qa_message` VALUES ('24', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 01:10:32', '2025-11-17 07:10:32', '1');
INSERT INTO `qa_message` VALUES ('25', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 00:40:32', null, null);
INSERT INTO `qa_message` VALUES ('26', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 00:55:32', null, null);
INSERT INTO `qa_message` VALUES ('27', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 00:10:32', null, null);
INSERT INTO `qa_message` VALUES ('28', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 00:25:32', null, null);
INSERT INTO `qa_message` VALUES ('29', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-19 21:10:32', '2025-11-19 21:40:32', '1');
INSERT INTO `qa_message` VALUES ('30', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 01:10:32', '2025-11-19 03:10:32', '1');
INSERT INTO `qa_message` VALUES ('31', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 00:50:32', null, null);
INSERT INTO `qa_message` VALUES ('32', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-19 23:40:32', null, null);
INSERT INTO `qa_message` VALUES ('33', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-19 20:10:32', '2025-11-19 20:50:32', '1');
INSERT INTO `qa_message` VALUES ('34', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-19 19:10:32', '2025-11-19 19:40:32', '1');
INSERT INTO `qa_message` VALUES ('35', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 01:00:32', null, null);
INSERT INTO `qa_message` VALUES ('36', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-19 23:10:32', null, null);
INSERT INTO `qa_message` VALUES ('37', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-19 18:10:32', '2025-11-19 18:55:32', '2');
INSERT INTO `qa_message` VALUES ('38', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 00:45:32', null, null);
INSERT INTO `qa_message` VALUES ('39', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-19 23:10:39', '2025-11-19 23:20:39', '1');
INSERT INTO `qa_message` VALUES ('40', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-19 22:10:39', '2025-11-19 22:40:39', '1');
INSERT INTO `qa_message` VALUES ('41', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 01:10:39', '2025-11-19 02:10:39', '1');
INSERT INTO `qa_message` VALUES ('42', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 01:10:39', '2025-11-18 05:10:39', '1');
INSERT INTO `qa_message` VALUES ('43', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 01:10:39', '2025-11-17 07:10:39', '1');
INSERT INTO `qa_message` VALUES ('44', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 00:40:39', null, null);
INSERT INTO `qa_message` VALUES ('45', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 00:55:39', null, null);
INSERT INTO `qa_message` VALUES ('46', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 00:10:39', null, null);
INSERT INTO `qa_message` VALUES ('47', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 00:25:39', null, null);
INSERT INTO `qa_message` VALUES ('48', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-19 21:10:39', '2025-11-19 21:40:39', '1');
INSERT INTO `qa_message` VALUES ('49', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 01:10:39', '2025-11-19 03:10:39', '1');
INSERT INTO `qa_message` VALUES ('50', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 00:50:39', null, null);
INSERT INTO `qa_message` VALUES ('51', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-19 23:40:39', null, null);
INSERT INTO `qa_message` VALUES ('52', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-19 20:10:39', '2025-11-19 20:50:39', '1');
INSERT INTO `qa_message` VALUES ('53', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-19 19:10:39', '2025-11-19 19:40:39', '1');
INSERT INTO `qa_message` VALUES ('54', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 01:00:39', null, null);
INSERT INTO `qa_message` VALUES ('55', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-19 23:10:39', null, null);
INSERT INTO `qa_message` VALUES ('56', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-19 18:10:39', '2025-11-19 18:55:39', '2');
INSERT INTO `qa_message` VALUES ('57', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 00:45:39', null, null);
INSERT INTO `qa_message` VALUES ('58', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 06:49:42', '2025-11-20 06:59:42', '1');
INSERT INTO `qa_message` VALUES ('59', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 05:49:42', '2025-11-20 06:19:42', '1');
INSERT INTO `qa_message` VALUES ('60', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 08:49:42', '2025-11-19 09:49:42', '1');
INSERT INTO `qa_message` VALUES ('61', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 08:49:42', '2025-11-18 12:49:42', '1');
INSERT INTO `qa_message` VALUES ('62', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 08:49:42', '2025-11-17 14:49:42', '1');
INSERT INTO `qa_message` VALUES ('63', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 08:19:42', null, null);
INSERT INTO `qa_message` VALUES ('64', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', '好的', 'answered', '1', '2025-11-20 08:34:42', '2025-11-20 02:55:56', '1');
INSERT INTO `qa_message` VALUES ('65', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 07:49:42', null, null);
INSERT INTO `qa_message` VALUES ('66', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 08:04:42', null, null);
INSERT INTO `qa_message` VALUES ('67', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 04:49:42', '2025-11-20 05:19:42', '1');
INSERT INTO `qa_message` VALUES ('68', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 08:49:42', '2025-11-19 10:49:42', '1');
INSERT INTO `qa_message` VALUES ('69', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 08:29:42', null, null);
INSERT INTO `qa_message` VALUES ('70', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 07:19:42', null, null);
INSERT INTO `qa_message` VALUES ('71', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 03:49:42', '2025-11-20 04:29:42', '1');
INSERT INTO `qa_message` VALUES ('72', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 02:49:42', '2025-11-20 03:19:42', '1');
INSERT INTO `qa_message` VALUES ('73', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 08:39:42', null, null);
INSERT INTO `qa_message` VALUES ('74', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 06:49:42', null, null);
INSERT INTO `qa_message` VALUES ('75', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 01:49:42', '2025-11-20 02:34:42', '2');
INSERT INTO `qa_message` VALUES ('76', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 08:24:42', null, null);
INSERT INTO `qa_message` VALUES ('77', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 06:49:54', '2025-11-20 06:59:54', '1');
INSERT INTO `qa_message` VALUES ('78', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 05:49:54', '2025-11-20 06:19:54', '1');
INSERT INTO `qa_message` VALUES ('79', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 08:49:54', '2025-11-19 09:49:54', '1');
INSERT INTO `qa_message` VALUES ('80', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 08:49:54', '2025-11-18 12:49:54', '1');
INSERT INTO `qa_message` VALUES ('81', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 08:49:54', '2025-11-17 14:49:54', '1');
INSERT INTO `qa_message` VALUES ('82', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 08:19:54', null, null);
INSERT INTO `qa_message` VALUES ('83', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', '好的', 'answered', '1', '2025-11-20 08:34:54', '2025-11-20 02:50:48', '1');
INSERT INTO `qa_message` VALUES ('84', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 07:49:54', null, null);
INSERT INTO `qa_message` VALUES ('85', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 08:04:54', null, null);
INSERT INTO `qa_message` VALUES ('86', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 04:49:54', '2025-11-20 05:19:54', '1');
INSERT INTO `qa_message` VALUES ('87', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 08:49:54', '2025-11-19 10:49:54', '1');
INSERT INTO `qa_message` VALUES ('88', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 08:29:54', null, null);
INSERT INTO `qa_message` VALUES ('89', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 07:19:54', null, null);
INSERT INTO `qa_message` VALUES ('90', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 03:49:54', '2025-11-20 04:29:54', '1');
INSERT INTO `qa_message` VALUES ('91', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 02:49:54', '2025-11-20 03:19:54', '1');
INSERT INTO `qa_message` VALUES ('92', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 08:39:54', null, null);
INSERT INTO `qa_message` VALUES ('93', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 06:49:54', null, null);
INSERT INTO `qa_message` VALUES ('94', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 01:49:54', '2025-11-20 02:34:54', '2');
INSERT INTO `qa_message` VALUES ('95', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 08:24:54', null, null);
INSERT INTO `qa_message` VALUES ('96', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:46:06', '2025-11-20 10:56:06', '1');
INSERT INTO `qa_message` VALUES ('97', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:46:06', '2025-11-20 10:16:06', '1');
INSERT INTO `qa_message` VALUES ('98', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:46:06', '2025-11-19 13:46:06', '1');
INSERT INTO `qa_message` VALUES ('99', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:46:06', '2025-11-18 16:46:06', '1');
INSERT INTO `qa_message` VALUES ('100', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:46:06', '2025-11-17 18:46:06', '1');
INSERT INTO `qa_message` VALUES ('101', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:16:06', null, null);
INSERT INTO `qa_message` VALUES ('102', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:31:06', null, null);
INSERT INTO `qa_message` VALUES ('103', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:46:06', null, null);
INSERT INTO `qa_message` VALUES ('104', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:01:06', null, null);
INSERT INTO `qa_message` VALUES ('105', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:46:06', '2025-11-20 09:16:06', '1');
INSERT INTO `qa_message` VALUES ('106', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:46:06', '2025-11-19 14:46:06', '1');
INSERT INTO `qa_message` VALUES ('107', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:26:06', null, null);
INSERT INTO `qa_message` VALUES ('108', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:16:06', null, null);
INSERT INTO `qa_message` VALUES ('109', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:46:06', '2025-11-20 08:26:06', '1');
INSERT INTO `qa_message` VALUES ('110', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:46:06', '2025-11-20 07:16:06', '1');
INSERT INTO `qa_message` VALUES ('111', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:36:06', null, null);
INSERT INTO `qa_message` VALUES ('112', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:46:06', null, null);
INSERT INTO `qa_message` VALUES ('113', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:46:06', '2025-11-20 06:31:06', '2');
INSERT INTO `qa_message` VALUES ('114', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:21:06', null, null);
INSERT INTO `qa_message` VALUES ('115', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:46:11', '2025-11-20 10:56:11', '1');
INSERT INTO `qa_message` VALUES ('116', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:46:11', '2025-11-20 10:16:11', '1');
INSERT INTO `qa_message` VALUES ('117', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:46:11', '2025-11-19 13:46:11', '1');
INSERT INTO `qa_message` VALUES ('118', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:46:11', '2025-11-18 16:46:11', '1');
INSERT INTO `qa_message` VALUES ('119', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:46:11', '2025-11-17 18:46:11', '1');
INSERT INTO `qa_message` VALUES ('120', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:16:11', null, null);
INSERT INTO `qa_message` VALUES ('121', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:31:11', null, null);
INSERT INTO `qa_message` VALUES ('122', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:46:11', null, null);
INSERT INTO `qa_message` VALUES ('123', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:01:11', null, null);
INSERT INTO `qa_message` VALUES ('124', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:46:11', '2025-11-20 09:16:11', '1');
INSERT INTO `qa_message` VALUES ('125', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:46:11', '2025-11-19 14:46:11', '1');
INSERT INTO `qa_message` VALUES ('126', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:26:11', null, null);
INSERT INTO `qa_message` VALUES ('127', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:16:11', null, null);
INSERT INTO `qa_message` VALUES ('128', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:46:11', '2025-11-20 08:26:11', '1');
INSERT INTO `qa_message` VALUES ('129', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:46:11', '2025-11-20 07:16:11', '1');
INSERT INTO `qa_message` VALUES ('130', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:36:11', null, null);
INSERT INTO `qa_message` VALUES ('131', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:46:11', null, null);
INSERT INTO `qa_message` VALUES ('132', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:46:11', '2025-11-20 06:31:11', '2');
INSERT INTO `qa_message` VALUES ('133', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:21:11', null, null);
INSERT INTO `qa_message` VALUES ('134', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:50:08', '2025-11-20 11:00:08', '1');
INSERT INTO `qa_message` VALUES ('135', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:50:08', '2025-11-20 10:20:08', '1');
INSERT INTO `qa_message` VALUES ('136', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:50:08', '2025-11-19 13:50:08', '1');
INSERT INTO `qa_message` VALUES ('137', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:50:08', '2025-11-18 16:50:08', '1');
INSERT INTO `qa_message` VALUES ('138', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:50:08', '2025-11-17 18:50:08', '1');
INSERT INTO `qa_message` VALUES ('139', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:20:08', null, null);
INSERT INTO `qa_message` VALUES ('140', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:35:08', null, null);
INSERT INTO `qa_message` VALUES ('141', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:50:08', null, null);
INSERT INTO `qa_message` VALUES ('142', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:05:08', null, null);
INSERT INTO `qa_message` VALUES ('143', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:50:08', '2025-11-20 09:20:08', '1');
INSERT INTO `qa_message` VALUES ('144', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:50:08', '2025-11-19 14:50:08', '1');
INSERT INTO `qa_message` VALUES ('145', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:30:08', null, null);
INSERT INTO `qa_message` VALUES ('146', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:20:08', null, null);
INSERT INTO `qa_message` VALUES ('147', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:50:08', '2025-11-20 08:30:08', '1');
INSERT INTO `qa_message` VALUES ('148', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:50:08', '2025-11-20 07:20:08', '1');
INSERT INTO `qa_message` VALUES ('149', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:40:08', null, null);
INSERT INTO `qa_message` VALUES ('150', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:50:08', null, null);
INSERT INTO `qa_message` VALUES ('151', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:50:08', '2025-11-20 06:35:08', '2');
INSERT INTO `qa_message` VALUES ('152', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:25:08', null, null);
INSERT INTO `qa_message` VALUES ('153', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:50:10', '2025-11-20 11:00:10', '1');
INSERT INTO `qa_message` VALUES ('154', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:50:10', '2025-11-20 10:20:10', '1');
INSERT INTO `qa_message` VALUES ('155', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:50:10', '2025-11-19 13:50:10', '1');
INSERT INTO `qa_message` VALUES ('156', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:50:10', '2025-11-18 16:50:10', '1');
INSERT INTO `qa_message` VALUES ('157', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:50:10', '2025-11-17 18:50:10', '1');
INSERT INTO `qa_message` VALUES ('158', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:20:10', null, null);
INSERT INTO `qa_message` VALUES ('159', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:35:10', null, null);
INSERT INTO `qa_message` VALUES ('160', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:50:10', null, null);
INSERT INTO `qa_message` VALUES ('161', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:05:10', null, null);
INSERT INTO `qa_message` VALUES ('162', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:50:10', '2025-11-20 09:20:10', '1');
INSERT INTO `qa_message` VALUES ('163', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:50:10', '2025-11-19 14:50:10', '1');
INSERT INTO `qa_message` VALUES ('164', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:30:10', null, null);
INSERT INTO `qa_message` VALUES ('165', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:20:10', null, null);
INSERT INTO `qa_message` VALUES ('166', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:50:10', '2025-11-20 08:30:10', '1');
INSERT INTO `qa_message` VALUES ('167', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:50:10', '2025-11-20 07:20:10', '1');
INSERT INTO `qa_message` VALUES ('168', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:40:10', null, null);
INSERT INTO `qa_message` VALUES ('169', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:50:10', null, null);
INSERT INTO `qa_message` VALUES ('170', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:50:10', '2025-11-20 06:35:10', '2');
INSERT INTO `qa_message` VALUES ('171', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:25:10', null, null);
INSERT INTO `qa_message` VALUES ('172', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:53:52', '2025-11-20 11:03:52', '1');
INSERT INTO `qa_message` VALUES ('173', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:53:52', '2025-11-20 10:23:52', '1');
INSERT INTO `qa_message` VALUES ('174', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:53:52', '2025-11-19 13:53:52', '1');
INSERT INTO `qa_message` VALUES ('175', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:53:52', '2025-11-18 16:53:52', '1');
INSERT INTO `qa_message` VALUES ('176', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:53:52', '2025-11-17 18:53:52', '1');
INSERT INTO `qa_message` VALUES ('177', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:23:52', null, null);
INSERT INTO `qa_message` VALUES ('178', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:38:52', null, null);
INSERT INTO `qa_message` VALUES ('179', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:53:52', null, null);
INSERT INTO `qa_message` VALUES ('180', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:08:52', null, null);
INSERT INTO `qa_message` VALUES ('181', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:53:52', '2025-11-20 09:23:52', '1');
INSERT INTO `qa_message` VALUES ('182', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:53:52', '2025-11-19 14:53:52', '1');
INSERT INTO `qa_message` VALUES ('183', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:33:52', null, null);
INSERT INTO `qa_message` VALUES ('184', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:23:52', null, null);
INSERT INTO `qa_message` VALUES ('185', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:53:52', '2025-11-20 08:33:52', '1');
INSERT INTO `qa_message` VALUES ('186', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:53:52', '2025-11-20 07:23:52', '1');
INSERT INTO `qa_message` VALUES ('187', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:43:52', null, null);
INSERT INTO `qa_message` VALUES ('188', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:53:52', null, null);
INSERT INTO `qa_message` VALUES ('189', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:53:52', '2025-11-20 06:38:52', '2');
INSERT INTO `qa_message` VALUES ('190', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:28:52', null, null);
INSERT INTO `qa_message` VALUES ('191', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 10:53:54', '2025-11-20 11:03:54', '1');
INSERT INTO `qa_message` VALUES ('192', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 09:53:54', '2025-11-20 10:23:54', '1');
INSERT INTO `qa_message` VALUES ('193', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 12:53:54', '2025-11-19 13:53:54', '1');
INSERT INTO `qa_message` VALUES ('194', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 12:53:54', '2025-11-18 16:53:54', '1');
INSERT INTO `qa_message` VALUES ('195', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 12:53:54', '2025-11-17 18:53:54', '1');
INSERT INTO `qa_message` VALUES ('196', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 12:23:54', null, null);
INSERT INTO `qa_message` VALUES ('197', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:38:54', null, null);
INSERT INTO `qa_message` VALUES ('198', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 11:53:54', null, null);
INSERT INTO `qa_message` VALUES ('199', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 12:08:54', null, null);
INSERT INTO `qa_message` VALUES ('200', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 08:53:54', '2025-11-20 09:23:54', '1');
INSERT INTO `qa_message` VALUES ('201', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 12:53:54', '2025-11-19 14:53:54', '1');
INSERT INTO `qa_message` VALUES ('202', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 12:33:54', null, null);
INSERT INTO `qa_message` VALUES ('203', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 11:23:54', null, null);
INSERT INTO `qa_message` VALUES ('204', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 07:53:54', '2025-11-20 08:33:54', '1');
INSERT INTO `qa_message` VALUES ('205', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 06:53:54', '2025-11-20 07:23:54', '1');
INSERT INTO `qa_message` VALUES ('206', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 12:43:54', null, null);
INSERT INTO `qa_message` VALUES ('207', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 10:53:54', null, null);
INSERT INTO `qa_message` VALUES ('208', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 05:53:54', '2025-11-20 06:38:54', '2');
INSERT INTO `qa_message` VALUES ('209', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 12:28:54', null, null);
INSERT INTO `qa_message` VALUES ('210', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 16:13:37', '2025-11-20 16:23:37', '1');
INSERT INTO `qa_message` VALUES ('211', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 15:13:37', '2025-11-20 15:43:37', '1');
INSERT INTO `qa_message` VALUES ('212', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 18:13:37', '2025-11-19 19:13:37', '1');
INSERT INTO `qa_message` VALUES ('213', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 18:13:37', '2025-11-18 22:13:37', '1');
INSERT INTO `qa_message` VALUES ('214', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 18:13:37', '2025-11-18 00:13:37', '1');
INSERT INTO `qa_message` VALUES ('215', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 17:43:37', null, null);
INSERT INTO `qa_message` VALUES ('216', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 17:58:37', null, null);
INSERT INTO `qa_message` VALUES ('217', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 17:13:37', null, null);
INSERT INTO `qa_message` VALUES ('218', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 17:28:37', null, null);
INSERT INTO `qa_message` VALUES ('219', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 14:13:37', '2025-11-20 14:43:37', '1');
INSERT INTO `qa_message` VALUES ('220', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 18:13:37', '2025-11-19 20:13:37', '1');
INSERT INTO `qa_message` VALUES ('221', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 17:53:37', null, null);
INSERT INTO `qa_message` VALUES ('222', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 16:43:37', null, null);
INSERT INTO `qa_message` VALUES ('223', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 13:13:37', '2025-11-20 13:53:37', '1');
INSERT INTO `qa_message` VALUES ('224', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 12:13:37', '2025-11-20 12:43:37', '1');
INSERT INTO `qa_message` VALUES ('225', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:03:37', null, null);
INSERT INTO `qa_message` VALUES ('226', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 16:13:37', null, null);
INSERT INTO `qa_message` VALUES ('227', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 11:13:37', '2025-11-20 11:58:37', '2');
INSERT INTO `qa_message` VALUES ('228', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 17:48:37', null, null);
INSERT INTO `qa_message` VALUES ('229', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 16:13:55', '2025-11-20 16:23:55', '1');
INSERT INTO `qa_message` VALUES ('230', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 15:13:55', '2025-11-20 15:43:55', '1');
INSERT INTO `qa_message` VALUES ('231', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 18:13:55', '2025-11-19 19:13:55', '1');
INSERT INTO `qa_message` VALUES ('232', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 18:13:55', '2025-11-18 22:13:55', '1');
INSERT INTO `qa_message` VALUES ('233', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 18:13:55', '2025-11-18 00:13:55', '1');
INSERT INTO `qa_message` VALUES ('234', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 17:43:55', null, null);
INSERT INTO `qa_message` VALUES ('235', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 17:58:55', null, null);
INSERT INTO `qa_message` VALUES ('236', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 17:13:55', null, null);
INSERT INTO `qa_message` VALUES ('237', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 17:28:55', null, null);
INSERT INTO `qa_message` VALUES ('238', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 14:13:55', '2025-11-20 14:43:55', '1');
INSERT INTO `qa_message` VALUES ('239', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 18:13:55', '2025-11-19 20:13:55', '1');
INSERT INTO `qa_message` VALUES ('240', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 17:53:55', null, null);
INSERT INTO `qa_message` VALUES ('241', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 16:43:55', null, null);
INSERT INTO `qa_message` VALUES ('242', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 13:13:55', '2025-11-20 13:53:55', '1');
INSERT INTO `qa_message` VALUES ('243', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 12:13:55', '2025-11-20 12:43:55', '1');
INSERT INTO `qa_message` VALUES ('244', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:03:55', null, null);
INSERT INTO `qa_message` VALUES ('245', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 16:13:55', null, null);
INSERT INTO `qa_message` VALUES ('246', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 11:13:55', '2025-11-20 11:58:55', '2');
INSERT INTO `qa_message` VALUES ('247', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 17:48:55', null, null);
INSERT INTO `qa_message` VALUES ('248', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 16:53:41', '2025-11-20 17:03:41', '1');
INSERT INTO `qa_message` VALUES ('249', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 15:53:41', '2025-11-20 16:23:41', '1');
INSERT INTO `qa_message` VALUES ('250', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 18:53:41', '2025-11-19 19:53:41', '1');
INSERT INTO `qa_message` VALUES ('251', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 18:53:41', '2025-11-18 22:53:41', '1');
INSERT INTO `qa_message` VALUES ('252', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 18:53:41', '2025-11-18 00:53:41', '1');
INSERT INTO `qa_message` VALUES ('253', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 18:23:41', null, null);
INSERT INTO `qa_message` VALUES ('254', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:38:41', null, null);
INSERT INTO `qa_message` VALUES ('255', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 17:53:41', null, null);
INSERT INTO `qa_message` VALUES ('256', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 18:08:41', null, null);
INSERT INTO `qa_message` VALUES ('257', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 14:53:41', '2025-11-20 15:23:41', '1');
INSERT INTO `qa_message` VALUES ('258', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 18:53:41', '2025-11-19 20:53:41', '1');
INSERT INTO `qa_message` VALUES ('259', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 18:33:41', null, null);
INSERT INTO `qa_message` VALUES ('260', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 17:23:41', null, null);
INSERT INTO `qa_message` VALUES ('261', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 13:53:41', '2025-11-20 14:33:41', '1');
INSERT INTO `qa_message` VALUES ('262', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 12:53:41', '2025-11-20 13:23:41', '1');
INSERT INTO `qa_message` VALUES ('263', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:43:41', null, null);
INSERT INTO `qa_message` VALUES ('264', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 16:53:41', null, null);
INSERT INTO `qa_message` VALUES ('265', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 11:53:41', '2025-11-20 12:38:41', '2');
INSERT INTO `qa_message` VALUES ('266', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 18:28:41', null, null);
INSERT INTO `qa_message` VALUES ('267', '1', '1', '王同学', '老师，这个公式的推导过程能再详细讲解一下吗？', '好的，这个公式的推导主要分为三步：第一步是建立基础假设，第二步是应用数学原理，第三步是验证结果。具体来说...', 'answered', '0', '2025-11-20 16:53:44', '2025-11-20 17:03:44', '1');
INSERT INTO `qa_message` VALUES ('268', '1', '2', '刘同学', '请问这个知识点在考试中会怎么出题？', '这个知识点在考试中通常会以选择题和简答题的形式出现。选择题主要考查基础概念，简答题会要求你结合具体例子说明。建议你重点复习...', 'answered', '1', '2025-11-20 15:53:44', '2025-11-20 16:23:44', '1');
INSERT INTO `qa_message` VALUES ('269', '1', '4', '李同学', '老师，我理解了这个概念，但不知道如何应用到实际中', '很好的问题！实际应用时需要注意以下几点：1. 理解概念的本质 2. 找到合适的应用场景 3. 注意细节处理。我给你举个例子...', 'answered', '0', '2025-11-19 18:53:44', '2025-11-19 19:53:44', '1');
INSERT INTO `qa_message` VALUES ('270', '1', '5', '张同学', '老师，文言文中的\"之\"字有哪些用法？', '文言文中的\"之\"字主要有以下几种用法：1. 作代词，代指人或物 2. 作助词，相当于\"的\" 3. 作动词，表示\"到、往\" 4. 作语气词。每种用法都有其特定的语境...', 'answered', '0', '2025-11-18 18:53:44', '2025-11-18 22:53:44', '1');
INSERT INTO `qa_message` VALUES ('271', '1', '6', '赵同学', '老师，现代文阅读中如何快速找到文章的主旨？', '找文章主旨有几个技巧：1. 看标题和首尾段 2. 找中心句 3. 注意反复出现的词语 4. 理解作者的情感倾向。多练习几篇，你就能掌握规律了。', 'answered', '0', '2025-11-17 18:53:44', '2025-11-18 00:53:44', '1');
INSERT INTO `qa_message` VALUES ('272', '1', '1', '王同学', '老师，关于昨天讲的古诗词，我想知道如何更好地记忆和理解？', null, 'pending', '0', '2025-11-20 18:23:44', null, null);
INSERT INTO `qa_message` VALUES ('273', '1', '2', '刘同学', '老师，这个作业的第3题我不太明白，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:38:44', null, null);
INSERT INTO `qa_message` VALUES ('274', '1', '4', '李同学', '老师，我想提高作文水平，有什么好的方法吗？', null, 'pending', '0', '2025-11-20 17:53:44', null, null);
INSERT INTO `qa_message` VALUES ('275', '1', '5', '张同学', '老师，文言文翻译有什么技巧吗？我总是翻译不准确。', null, 'pending', '0', '2025-11-20 18:08:44', null, null);
INSERT INTO `qa_message` VALUES ('276', '2', '3', '陈同学', '老师，阅读理解中如何分析文章的结构？', '分析文章结构可以从以下几个方面入手：1. 段落之间的关系 2. 文章的逻辑顺序 3. 开头和结尾的作用 4. 过渡句的作用。建议你多读几篇不同类型的文章...', 'answered', '0', '2025-11-20 14:53:44', '2025-11-20 15:23:44', '1');
INSERT INTO `qa_message` VALUES ('277', '2', '7', '孙同学', '老师，如何提高语文成绩？', '提高语文成绩需要多方面的努力：1. 多读书，增加阅读量 2. 多练习，特别是阅读和写作 3. 注意积累词汇和成语 4. 理解文章的主旨和作者意图。坚持每天学习，一定会有进步的。', 'answered', '0', '2025-11-19 18:53:44', '2025-11-19 20:53:44', '1');
INSERT INTO `qa_message` VALUES ('278', '2', '8', '周同学', '老师，这个知识点在课本的哪一页？', null, 'pending', '0', '2025-11-20 18:33:44', null, null);
INSERT INTO `qa_message` VALUES ('279', '2', '3', '陈同学', '老师，我写作文时总是不知道写什么，怎么办？', null, 'pending', '0', '2025-11-20 17:23:44', null, null);
INSERT INTO `qa_message` VALUES ('280', '3', '9', '吴同学', '老师，分数运算有什么技巧吗？', '分数运算的技巧主要有：1. 通分要找到最小公倍数 2. 约分要找到最大公约数 3. 注意运算顺序 4. 结果要化成最简分数。多做练习，熟能生巧。', 'answered', '0', '2025-11-20 13:53:44', '2025-11-20 14:33:44', '1');
INSERT INTO `qa_message` VALUES ('281', '3', '10', '郑同学', '老师，明天考试会考哪些内容？', '明天考试主要考查：1. 整数运算 2. 分数运算 3. 应用题 4. 几何初步。建议你重点复习这几个部分，特别是分数运算和应用题。', 'answered', '1', '2025-11-20 12:53:44', '2025-11-20 13:23:44', '1');
INSERT INTO `qa_message` VALUES ('282', '3', '11', '钱同学', '老师，这道数学题我不会做，能帮我看看吗？', null, 'pending', '1', '2025-11-20 18:43:44', null, null);
INSERT INTO `qa_message` VALUES ('283', '3', '9', '吴同学', '老师，如何提高数学解题速度？', null, 'pending', '0', '2025-11-20 16:53:44', null, null);
INSERT INTO `qa_message` VALUES ('284', '4', '12', '马同学', '老师，英语单词怎么记才能记得牢？', '记英语单词有几个好方法：1. 音标记忆法，根据发音记单词 2. 词根词缀法，理解单词的构成 3. 联想记忆法，把单词和熟悉的事物联系起来 4. 反复复习，及时巩固。建议你每天记20-30个单词...', 'answered', '0', '2025-11-20 11:53:44', '2025-11-20 12:38:44', '2');
INSERT INTO `qa_message` VALUES ('285', '4', '12', '马同学', '老师，英语语法中的时态我总是搞混，有什么好的学习方法吗？', null, 'pending', '0', '2025-11-20 18:28:44', null, null);

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '题库名称',
  `description` text COMMENT '题库描述',
  `question` text NOT NULL COMMENT '题目内容',
  `answer` text COMMENT '答案',
  `type` varchar(50) DEFAULT 'choice' COMMENT '题型：choice/fill/judge/subjective',
  `options` text COMMENT '选项（JSON字符串，仅选择题）',
  `difficulty` varchar(50) DEFAULT NULL COMMENT '难度：简单/中等/困难',
  `knowledge_point` varchar(255) DEFAULT NULL COMMENT '知识点',
  `source` varchar(50) DEFAULT 'upload' COMMENT '来源：upload/manual',
  `file_name` varchar(255) DEFAULT NULL COMMENT '上传的文件名',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `md5` varchar(32) NOT NULL COMMENT '题目唯一标识（用于去重）',
  `target_layer` varchar(50) DEFAULT NULL COMMENT '目标层级：基础层、提高层、拓展层',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_type` (`type`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_knowledge_point` (`knowledge_point`),
  KEY `idx_md5` (`md5`),
  CONSTRAINT `question_bank_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='题库表';

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES ('1', '1', '题库', '题库', '《观沧海》的作者是谁？', '曹操', 'choice', null, '简单', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', '662d6a9788edb86dc9bfe434fb41488b', '基础层');
INSERT INTO `question_bank` VALUES ('2', '1', '题库', '题库', '《观沧海》中\'水何澹澹\'描绘的是____的景象。', '海面壮阔', 'fill', null, '简单', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'c69efcc2f4cd0c2a0e4b04ae3718eb09', '基础层');
INSERT INTO `question_bank` VALUES ('3', '1', '题库', '题库', '《观沧海》是曹操创作的一首乐府诗。', '正确', 'judge', null, '简单', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'b8dcd324c71ddba520bab39024bb8504', '基础层');
INSERT INTO `question_bank` VALUES ('4', '1', '题库', '题库', '请简要概括《观沧海》这首诗的主要内容。', '这首诗通过描绘沧海的壮阔景象，表达了作者曹操的博大胸襟和统一天下的雄心壮志。', 'subjective', null, '简单', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', '0663db39777aa5602d427885b726315b', '基础层');
INSERT INTO `question_bank` VALUES ('5', '1', '题库', '题库', '《观沧海》中\'日月之行，若出其中\'运用了哪种修辞手法？', '夸张', 'choice', null, '中等', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', '499a7364f61d86e6735f6df78ffdbbfb', '提高层');
INSERT INTO `question_bank` VALUES ('6', '1', '题库', '题库', '《观沧海》中\'____，若出其里\'描绘了星汉灿烂的景象。', '星汉灿烂', 'fill', null, '中等', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'c824dccabafd5044fb75b8fcd241db9b', '提高层');
INSERT INTO `question_bank` VALUES ('7', '1', '题库', '题库', '《观沧海》中，曹操通过描绘沧海的壮阔景象，表达了对国家统一和个人抱负的追求。', '正确', 'judge', null, '中等', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'cc3caa62d546bbba18ba8c99a151841d', '提高层');
INSERT INTO `question_bank` VALUES ('8', '1', '题库', '题库', '《观沧海》中，曹操通过描绘\'日月之行，若出其中；星汉灿烂，若出其里\'的景象，表达了他怎样的胸怀和抱负？请结合诗句简要分析。', '这两句诗运用夸张的修辞手法，将日月星辰的运行都纳入沧海的怀抱，表现了曹操博大的胸襟和统一天下的雄心壮志。', 'subjective', null, '中等', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', '1df02648b5cbf3b43cdde5c7a89c9a83', '提高层');
INSERT INTO `question_bank` VALUES ('9', '1', '题库', '题库', '《观沧海》中\'星汉灿烂，若出其里\'的\'星汉\'指的是什么？', '银河', 'choice', null, '困难', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'c1d8d8910eeeb3f46421bba6f713d3f2', '拓展层');
INSERT INTO `question_bank` VALUES ('10', '1', '题库', '题库', '《观沧海》中\'水何澹澹\'描绘的是____的景象，而\'山岛竦峙\'则通过____的手法展现了自然景观的壮阔。', '海面壮阔;对比', 'fill', null, '困难', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', 'ce1dc713d869dbb0797f3b2792606373', '拓展层');
INSERT INTO `question_bank` VALUES ('11', '1', '题库', '题库', '《观沧海》中，曹操通过描绘沧海景象来展现其雄才大略和政治抱负，诗中哪些意象和修辞手法强化了这一主题的表达？', '诗中通过\'日月之行\'、\'星汉灿烂\'等意象，运用夸张、对比等修辞手法，将自然景象与个人抱负相结合，强化了主题表达。', 'subjective', null, '困难', '古诗词', 'upload', '题库示例.csv', '2025-11-20 09:18:02', '4d51b47ef265b27e6954ee6637423098', '拓展层');

-- ----------------------------
-- Table structure for resource_history
-- ----------------------------
DROP TABLE IF EXISTS `resource_history`;
CREATE TABLE `resource_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `resource_type` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `cover_url` varchar(500) DEFAULT NULL,
  `resource_url` varchar(500) DEFAULT NULL,
  `extra` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_res_user_id` (`user_id`),
  KEY `idx_res_type` (`resource_type`),
  KEY `idx_res_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of resource_history
-- ----------------------------

-- ----------------------------
-- Table structure for resource_usage
-- ----------------------------
DROP TABLE IF EXISTS `resource_usage`;
CREATE TABLE `resource_usage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL,
  `resource_key` varchar(255) DEFAULT NULL,
  `usage_count` int(11) DEFAULT '1',
  `last_used` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `resource_usage_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of resource_usage
-- ----------------------------
INSERT INTO `resource_usage` VALUES ('1', '1', 'ppt_lesson1', '15', '2025-11-20 18:53:44');
INSERT INTO `resource_usage` VALUES ('2', '1', 'video_lesson2', '8', '2025-11-19 18:53:44');
INSERT INTO `resource_usage` VALUES ('3', '1', 'audio_lesson3', '12', '2025-11-18 18:53:44');
INSERT INTO `resource_usage` VALUES ('4', '1', 'image_lesson4', '20', '2025-11-17 18:53:44');
INSERT INTO `resource_usage` VALUES ('5', '2', 'ppt_math1', '18', '2025-11-20 18:53:44');
INSERT INTO `resource_usage` VALUES ('6', '2', 'video_math2', '10', '2025-11-19 18:53:44');
INSERT INTO `resource_usage` VALUES ('7', '3', 'ppt_english1', '22', '2025-11-20 18:53:44');
INSERT INTO `resource_usage` VALUES ('8', '3', 'audio_english2', '14', '2025-11-19 18:53:44');
INSERT INTO `resource_usage` VALUES ('9', '1', 'ppt_lesson5', '12', '2025-11-16 18:53:44');
INSERT INTO `resource_usage` VALUES ('10', '1', 'ppt_lesson6', '10', '2025-11-15 18:53:44');
INSERT INTO `resource_usage` VALUES ('11', '1', 'video_lesson7', '9', '2025-11-14 18:53:44');
INSERT INTO `resource_usage` VALUES ('12', '1', 'audio_lesson8', '11', '2025-11-13 18:53:44');
INSERT INTO `resource_usage` VALUES ('13', '1', 'image_lesson9', '15', '2025-11-12 18:53:44');
INSERT INTO `resource_usage` VALUES ('14', '1', 'ppt_lesson10', '8', '2025-11-11 18:53:44');
INSERT INTO `resource_usage` VALUES ('15', '1', 'video_lesson11', '7', '2025-11-10 18:53:44');
INSERT INTO `resource_usage` VALUES ('16', '1', 'audio_lesson12', '6', '2025-11-09 18:53:44');

-- ----------------------------
-- Table structure for resource_usage_seq
-- ----------------------------
DROP TABLE IF EXISTS `resource_usage_seq`;
CREATE TABLE `resource_usage_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of resource_usage_seq
-- ----------------------------
INSERT INTO `resource_usage_seq` VALUES ('1');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `realname` varchar(100) NOT NULL,
  `clazz_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `clazz_id` (`clazz_id`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`clazz_id`) REFERENCES `clazz` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('1', 'student1', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '王同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('2', 'student2', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '刘同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('3', 'student3', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '陈同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('4', 'student4', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '李同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('5', 'student5', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '张同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('6', 'student6', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '赵同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('7', 'student7', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '孙同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('8', 'student8', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '周同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('9', 'student9', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '吴同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('10', 'student10', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '郑同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('11', 'student11', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '钱同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('12', 'student12', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '马同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('13', 'student13', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '黄同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('14', 'student14', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '林同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('15', 'student15', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '何同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('16', 'student16', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '高同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('17', 'student17', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '梁同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('18', 'student18', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '罗同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('19', 'student19', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '宋同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('20', 'student20', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '唐同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('21', 'student21', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '许同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('22', 'student22', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '韩同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('23', 'student23', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '冯同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('24', 'student24', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '于同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('25', 'student25', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '董同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('26', 'student26', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '萧同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('27', 'student27', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '程同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('28', 'student28', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '曹同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('29', 'student29', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '袁同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('30', 'student30', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '邓同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('31', 'student31', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '许同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('32', 'student32', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '傅同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('33', 'student33', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '沈同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('34', 'student34', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '曾同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('35', 'student35', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '彭同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('36', 'student36', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '吕同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('37', 'student37', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '苏同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('38', 'student38', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '卢同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('39', 'student39', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '蒋同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('40', 'student40', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '蔡同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('41', 'student41', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '贾同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('42', 'student42', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '丁同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('43', 'student43', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '魏同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('44', 'student44', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '薛同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('45', 'student45', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '叶同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('46', 'student46', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '阎同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('47', 'student47', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '余同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('48', 'student48', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '潘同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('49', 'student49', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '杜同学', '1', '2025-11-20 18:53:43');
INSERT INTO `student` VALUES ('50', 'student50', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '戴同学', '1', '2025-11-20 18:53:43');

-- ----------------------------
-- Table structure for student_homework_answer
-- ----------------------------
DROP TABLE IF EXISTS `student_homework_answer`;
CREATE TABLE `student_homework_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `homework_id` bigint(20) NOT NULL COMMENT '作业题目ID',
  `student_id` varchar(100) NOT NULL COMMENT '学生ID',
  `student_answer` text COMMENT '学生答案',
  `is_correct` tinyint(1) NOT NULL COMMENT '是否正确',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  PRIMARY KEY (`id`),
  KEY `idx_homework_id` (`homework_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_is_correct` (`is_correct`),
  KEY `idx_homework_student` (`homework_id`,`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5019 DEFAULT CHARSET=utf8mb4 COMMENT='学生答题记录表（用于错题分析）';

-- ----------------------------
-- Records of student_homework_answer
-- ----------------------------
INSERT INTO `student_homework_answer` VALUES ('4287', '1', '1', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4288', '1', '2', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4289', '1', '3', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4290', '1', '4', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4291', '1', '5', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4292', '1', '6', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4293', '1', '7', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4294', '1', '8', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4295', '1', '9', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4296', '1', '10', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4297', '1', '11', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4298', '1', '12', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4299', '1', '13', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4300', '1', '14', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4301', '1', '15', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4302', '1', '16', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4303', '1', '17', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4304', '1', '18', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4305', '1', '19', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4306', '1', '20', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4307', '1', '21', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4308', '1', '22', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4309', '1', '23', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4310', '1', '24', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4311', '1', '25', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4312', '1', '26', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4313', '1', '27', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4314', '1', '28', '错误答案', '0', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4318', '1', '29', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4319', '1', '30', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4320', '1', '31', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4321', '1', '32', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4322', '1', '33', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4323', '1', '34', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4324', '1', '35', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4325', '1', '36', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4326', '1', '37', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4327', '1', '38', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4328', '1', '39', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4329', '1', '40', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4330', '1', '41', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4331', '1', '42', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4332', '1', '43', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4333', '1', '44', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4334', '1', '45', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4335', '1', '46', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4336', '1', '47', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4337', '1', '48', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4338', '1', '49', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4339', '1', '50', '表达了作者对春天的热爱和对美好生活的向往', '1', '2025-11-19 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4349', '2', '1', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4350', '2', '2', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4351', '2', '3', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4352', '2', '4', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4353', '2', '5', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4354', '2', '6', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4355', '2', '7', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4356', '2', '8', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4357', '2', '9', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4358', '2', '10', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4359', '2', '11', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4360', '2', '12', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4361', '2', '13', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4362', '2', '14', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4363', '2', '15', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4364', '2', '16', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4365', '2', '17', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4366', '2', '18', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4367', '2', '19', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4368', '2', '20', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4369', '2', '21', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4370', '2', '22', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4371', '2', '23', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4372', '2', '24', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4373', '2', '25', '错误答案', '0', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4380', '2', '26', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4381', '2', '27', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4382', '2', '28', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4383', '2', '29', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4384', '2', '30', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4385', '2', '31', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4386', '2', '32', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4387', '2', '33', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4388', '2', '34', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4389', '2', '35', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4390', '2', '36', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4391', '2', '37', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4392', '2', '38', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4393', '2', '39', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4394', '2', '40', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4395', '2', '41', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4396', '2', '42', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4397', '2', '43', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4398', '2', '44', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4399', '2', '45', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4400', '2', '46', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4401', '2', '47', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4402', '2', '48', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4403', '2', '49', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4404', '2', '50', '陋：简陋', '1', '2025-11-18 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4411', '3', '1', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4412', '3', '2', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4413', '3', '3', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4414', '3', '4', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4415', '3', '5', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4416', '3', '6', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4417', '3', '7', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4418', '3', '8', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4419', '3', '9', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4420', '3', '10', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4421', '3', '11', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4422', '3', '12', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4423', '3', '13', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4424', '3', '14', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4425', '3', '15', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4426', '3', '16', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4427', '3', '17', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4428', '3', '18', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4429', '3', '19', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4430', '3', '20', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4431', '3', '21', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4432', '3', '22', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4433', '3', '23', '错误答案', '0', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4442', '3', '24', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4443', '3', '25', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4444', '3', '26', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4445', '3', '27', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4446', '3', '28', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4447', '3', '29', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4448', '3', '30', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4449', '3', '31', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4450', '3', '32', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4451', '3', '33', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4452', '3', '34', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4453', '3', '35', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4454', '3', '36', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4455', '3', '37', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4456', '3', '38', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4457', '3', '39', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4458', '3', '40', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4459', '3', '41', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4460', '3', '42', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4461', '3', '43', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4462', '3', '44', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4463', '3', '45', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4464', '3', '46', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4465', '3', '47', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4466', '3', '48', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4467', '3', '49', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4468', '3', '50', '总分总结构', '1', '2025-11-17 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4473', '4', '1', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4474', '4', '2', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4475', '4', '3', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4476', '4', '4', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4477', '4', '5', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4478', '4', '6', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4479', '4', '7', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4480', '4', '8', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4481', '4', '9', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4482', '4', '10', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4483', '4', '11', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4484', '4', '12', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4485', '4', '13', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4486', '4', '14', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4487', '4', '15', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4488', '4', '16', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4489', '4', '17', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4490', '4', '18', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4491', '4', '19', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4492', '4', '20', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4493', '4', '21', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4494', '4', '22', '错误答案', '0', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4504', '4', '23', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4505', '4', '24', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4506', '4', '25', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4507', '4', '26', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4508', '4', '27', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4509', '4', '28', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4510', '4', '29', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4511', '4', '30', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4512', '4', '31', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4513', '4', '32', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4514', '4', '33', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4515', '4', '34', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4516', '4', '35', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4517', '4', '36', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4518', '4', '37', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4519', '4', '38', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4520', '4', '39', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4521', '4', '40', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4522', '4', '41', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4523', '4', '42', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4524', '4', '43', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4525', '4', '44', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4526', '4', '45', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4527', '4', '46', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4528', '4', '47', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4529', '4', '48', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4530', '4', '49', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4531', '4', '50', '表达了诗人博大的胸襟和远大的政治抱负', '1', '2025-11-16 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4535', '5', '1', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4536', '5', '2', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4537', '5', '3', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4538', '5', '4', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4539', '5', '5', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4540', '5', '6', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4541', '5', '7', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4542', '5', '8', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4543', '5', '9', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4544', '5', '10', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4545', '5', '11', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4546', '5', '12', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4547', '5', '13', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4548', '5', '14', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4549', '5', '15', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4550', '5', '16', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4551', '5', '17', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4552', '5', '18', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4553', '5', '19', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4554', '5', '20', '错误答案', '0', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4566', '5', '21', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4567', '5', '22', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4568', '5', '23', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4569', '5', '24', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4570', '5', '25', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4571', '5', '26', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4572', '5', '27', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4573', '5', '28', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4574', '5', '29', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4575', '5', '30', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4576', '5', '31', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4577', '5', '32', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4578', '5', '33', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4579', '5', '34', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4580', '5', '35', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4581', '5', '36', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4582', '5', '37', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4583', '5', '38', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4584', '5', '39', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4585', '5', '40', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4586', '5', '41', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4587', '5', '42', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4588', '5', '43', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4589', '5', '44', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4590', '5', '45', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4591', '5', '46', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4592', '5', '47', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4593', '5', '48', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4594', '5', '49', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4595', '5', '50', '调整语序使句子通顺', '1', '2025-11-15 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4597', '6', '1', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4598', '6', '2', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4599', '6', '3', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4600', '6', '4', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4601', '6', '5', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4602', '6', '6', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4603', '6', '7', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4604', '6', '8', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4605', '6', '9', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4606', '6', '10', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4607', '6', '11', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4608', '6', '12', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4609', '6', '13', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4610', '6', '14', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4611', '6', '15', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4612', '6', '16', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4613', '6', '17', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4614', '6', '18', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4615', '6', '19', '错误答案', '0', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4628', '6', '20', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4629', '6', '21', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4630', '6', '22', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4631', '6', '23', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4632', '6', '24', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4633', '6', '25', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4634', '6', '26', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4635', '6', '27', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4636', '6', '28', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4637', '6', '29', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4638', '6', '30', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4639', '6', '31', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4640', '6', '32', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4641', '6', '33', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4642', '6', '34', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4643', '6', '35', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4644', '6', '36', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4645', '6', '37', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4646', '6', '38', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4647', '6', '39', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4648', '6', '40', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4649', '6', '41', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4650', '6', '42', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4651', '6', '43', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4652', '6', '44', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4653', '6', '45', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4654', '6', '46', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4655', '6', '47', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4656', '6', '48', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4657', '6', '49', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4658', '6', '50', '通过细节描写表现父爱的深沉', '1', '2025-11-14 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4659', '7', '1', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4660', '7', '2', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4661', '7', '3', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4662', '7', '4', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4663', '7', '5', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4664', '7', '6', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4665', '7', '7', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4666', '7', '8', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4667', '7', '9', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4668', '7', '10', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4669', '7', '11', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4670', '7', '12', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4671', '7', '13', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4672', '7', '14', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4673', '7', '15', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4674', '7', '16', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4675', '7', '17', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4676', '7', '18', '错误答案', '0', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4690', '7', '19', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4691', '7', '20', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4692', '7', '21', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4693', '7', '22', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4694', '7', '23', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4695', '7', '24', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4696', '7', '25', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4697', '7', '26', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4698', '7', '27', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4699', '7', '28', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4700', '7', '29', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4701', '7', '30', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4702', '7', '31', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4703', '7', '32', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4704', '7', '33', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4705', '7', '34', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4706', '7', '35', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4707', '7', '36', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4708', '7', '37', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4709', '7', '38', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4710', '7', '39', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4711', '7', '40', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4712', '7', '41', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4713', '7', '42', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4714', '7', '43', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4715', '7', '44', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4716', '7', '45', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4717', '7', '46', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4718', '7', '47', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4719', '7', '48', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4720', '7', '49', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4721', '7', '50', '引号用于引用或强调', '1', '2025-11-13 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4753', '8', '1', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4754', '8', '2', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4755', '8', '3', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4756', '8', '4', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4757', '8', '5', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4758', '8', '6', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4759', '8', '7', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4760', '8', '8', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4761', '8', '9', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4762', '8', '10', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4763', '8', '11', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4764', '8', '12', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4765', '8', '13', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4766', '8', '14', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4767', '8', '15', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4768', '8', '16', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4769', '8', '17', '错误答案', '0', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4784', '8', '18', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4785', '8', '19', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4786', '8', '20', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4787', '8', '21', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4788', '8', '22', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4789', '8', '23', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4790', '8', '24', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4791', '8', '25', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4792', '8', '26', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4793', '8', '27', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4794', '8', '28', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4795', '8', '29', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4796', '8', '30', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4797', '8', '31', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4798', '8', '32', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4799', '8', '33', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4800', '8', '34', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4801', '8', '35', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4802', '8', '36', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4803', '8', '37', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4804', '8', '38', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4805', '8', '39', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4806', '8', '40', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4807', '8', '41', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4808', '8', '42', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4809', '8', '43', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4810', '8', '44', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4811', '8', '45', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4812', '8', '46', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4813', '8', '47', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4814', '8', '48', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4815', '8', '49', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4816', '8', '50', '判断句、倒装句等', '1', '2025-11-12 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4847', '9', '1', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4848', '9', '2', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4849', '9', '3', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4850', '9', '4', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4851', '9', '5', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4852', '9', '6', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4853', '9', '7', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4854', '9', '8', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4855', '9', '9', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4856', '9', '10', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4857', '9', '11', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4858', '9', '12', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4859', '9', '13', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4860', '9', '14', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4861', '9', '15', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4862', '9', '16', '错误答案', '0', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4878', '9', '17', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4879', '9', '18', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4880', '9', '19', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4881', '9', '20', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4882', '9', '21', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4883', '9', '22', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4884', '9', '23', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4885', '9', '24', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4886', '9', '25', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4887', '9', '26', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4888', '9', '27', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4889', '9', '28', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4890', '9', '29', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4891', '9', '30', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4892', '9', '31', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4893', '9', '32', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4894', '9', '33', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4895', '9', '34', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4896', '9', '35', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4897', '9', '36', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4898', '9', '37', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4899', '9', '38', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4900', '9', '39', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4901', '9', '40', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4902', '9', '41', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4903', '9', '42', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4904', '9', '43', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4905', '9', '44', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4906', '9', '45', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4907', '9', '46', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4908', '9', '47', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4909', '9', '48', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4910', '9', '49', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4911', '9', '50', '举例子、列数字、作比较等', '1', '2025-11-11 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4941', '10', '1', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4942', '10', '2', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4943', '10', '3', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4944', '10', '4', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4945', '10', '5', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4946', '10', '6', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4947', '10', '7', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4948', '10', '8', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4949', '10', '9', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4950', '10', '10', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4951', '10', '11', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4952', '10', '12', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4953', '10', '13', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4954', '10', '14', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4955', '10', '15', '错误答案', '0', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4956', '10', '16', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4957', '10', '17', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4958', '10', '18', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4959', '10', '19', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4960', '10', '20', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4961', '10', '21', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4962', '10', '22', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4963', '10', '23', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4964', '10', '24', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4965', '10', '25', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4966', '10', '26', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4967', '10', '27', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4968', '10', '28', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4969', '10', '29', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4970', '10', '30', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4971', '10', '31', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4972', '10', '32', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4973', '10', '33', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4974', '10', '34', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4975', '10', '35', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4976', '10', '36', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4977', '10', '37', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4978', '10', '38', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4979', '10', '39', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4980', '10', '40', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4981', '10', '41', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4982', '10', '42', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4983', '10', '43', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4984', '10', '44', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4985', '10', '45', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4986', '10', '46', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4987', '10', '47', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4988', '10', '48', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4989', '10', '49', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');
INSERT INTO `student_homework_answer` VALUES ('4990', '10', '50', '通过细节描写表达真情实感', '1', '2025-11-10 18:53:44');

-- ----------------------------
-- Table structure for student_points
-- ----------------------------
DROP TABLE IF EXISTS `student_points`;
CREATE TABLE `student_points` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `clazz_id` bigint(20) NOT NULL COMMENT '班级ID',
  `student_id` bigint(20) NOT NULL COMMENT '学生ID',
  `student_name` varchar(100) DEFAULT NULL COMMENT '学生姓名（冗余字段）',
  `total_points` int(11) NOT NULL DEFAULT '0' COMMENT '总积分',
  `quick_answer_count` int(11) NOT NULL DEFAULT '0' COMMENT '抢答次数',
  `question_count` int(11) NOT NULL DEFAULT '0' COMMENT '提问次数',
  `reward_count` int(11) NOT NULL DEFAULT '0' COMMENT '奖励次数',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_clazz_student` (`clazz_id`,`student_id`),
  KEY `idx_clazz_id` (`clazz_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_total_points` (`total_points`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COMMENT='学生积分表';

-- ----------------------------
-- Records of student_points
-- ----------------------------
INSERT INTO `student_points` VALUES ('1', '1', '1', '王同学', '85', '12', '8', '5', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('2', '1', '2', '刘同学', '78', '10', '9', '4', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('3', '1', '4', '李同学', '72', '8', '7', '3', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('4', '1', '5', '张同学', '68', '9', '6', '2', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('5', '1', '6', '赵同学', '65', '7', '8', '3', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('6', '2', '3', '陈同学', '82', '11', '7', '4', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('7', '2', '7', '孙同学', '75', '9', '8', '3', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('8', '2', '8', '周同学', '70', '8', '6', '2', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('9', '3', '9', '吴同学', '88', '13', '9', '5', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('10', '3', '10', '郑同学', '80', '10', '8', '4', '2025-11-20 18:53:44');
INSERT INTO `student_points` VALUES ('11', '3', '11', '马同学', '73', '9', '7', '3', '2025-11-20 18:53:44');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `realname` varchar(100) NOT NULL,
  `course_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES ('1', 'teacher1', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '张老师', '1', '2025-11-20 18:53:43');
INSERT INTO `teacher` VALUES ('2', 'teacher2', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '李老师', null, '2025-11-20 18:53:43');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'teacher1', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '张老师', 'TEACHER', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('2', 'teacher2', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '李老师', 'TEACHER', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('3', 'student1', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '王同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('4', 'student2', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '刘同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('5', 'student3', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '陈同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('6', 'student4', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '李同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('7', 'student5', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '张同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('8', 'student6', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '赵同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('9', 'student7', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '孙同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('10', 'student8', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '周同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('11', 'student9', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '吴同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('12', 'student10', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '郑同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('13', 'student11', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '钱同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('14', 'student12', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '马同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('15', 'student13', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '黄同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('16', 'student14', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '林同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('17', 'student15', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '何同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('18', 'student16', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '高同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('19', 'student17', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '梁同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('20', 'student18', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '罗同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('21', 'student19', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '宋同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('22', 'student20', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '唐同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('23', 'student21', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '许同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('24', 'student22', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '韩同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('25', 'student23', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '冯同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('26', 'student24', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '于同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('27', 'student25', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '董同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('28', 'student26', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '萧同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('29', 'student27', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '程同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('30', 'student28', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '曹同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('31', 'student29', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '袁同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('32', 'student30', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '邓同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('33', 'student31', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '许同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('34', 'student32', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '傅同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('35', 'student33', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '沈同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('36', 'student34', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '曾同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('37', 'student35', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '彭同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('38', 'student36', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '吕同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('39', 'student37', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '苏同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('40', 'student38', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '卢同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('41', 'student39', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '蒋同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('42', 'student40', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '蔡同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('43', 'student41', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '贾同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('44', 'student42', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '丁同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('45', 'student43', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '魏同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('46', 'student44', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '薛同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('47', 'student45', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '叶同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('48', 'student46', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '阎同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('49', 'student47', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '余同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('50', 'student48', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '潘同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('51', 'student49', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '杜同学', 'STUDENT', '2025-11-20 18:53:43');
INSERT INTO `users` VALUES ('52', 'student50', '$2a$10$X8PQzgGcHwTMR6j4HK2STuiSf2A7AzpeAcDQEnRZncPVO/J8KA5Ci', '戴同学', 'STUDENT', '2025-11-20 18:53:43');

-- ----------------------------
-- Table structure for users_seq
-- ----------------------------
DROP TABLE IF EXISTS `users_seq`;
CREATE TABLE `users_seq` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users_seq
-- ----------------------------
INSERT INTO `users_seq` VALUES ('1');

-- ----------------------------
-- Table structure for video_history
-- ----------------------------
DROP TABLE IF EXISTS `video_history`;
CREATE TABLE `video_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `prompt` text,
  `video_url` varchar(500) NOT NULL,
  `duration_seconds` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `task_id` varchar(100) DEFAULT NULL,
  `source` varchar(50) DEFAULT 'bailian',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_video_user_id` (`user_id`),
  KEY `idx_video_task_id` (`task_id`),
  KEY `idx_video_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of video_history
-- ----------------------------
