/*
 Navicat Premium Data Transfer

 Source Server         : HealthManager
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : healthmanage

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 28/05/2026 14:54:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(BCrypt加密)',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色:super/admin/auditor',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '$2a$10$8R8EPFyfUjSMDkdnAcSoveVVcFyOX.R.LvqtUGoUDDGYTp/EA5CK.', 'super', '2026-05-15 14:35:38', '2026-05-15 14:41:58');
INSERT INTO `admin` VALUES (2, 'admin1', '$2a$10$hxVj4ykSdLM4Ofwqk2UNoeY1/.p3zSr2ijpxhpiVc82qiv1.pJA4a', 'super', '2026-05-15 14:41:43', '2026-05-15 14:41:43');
INSERT INTO `admin` VALUES (3, 'admin2', '$2a$10$Ytzc4LZFl5YDYy9jv8dADelVMeJJQLanbHzsJS.1vagCoE2mVmkyC', 'auditor', '2026-05-15 20:03:00', '2026-05-15 20:03:00');

-- ----------------------------
-- Table structure for assessment_question
-- ----------------------------
DROP TABLE IF EXISTS `assessment_question`;
CREATE TABLE `assessment_question`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `dimension` tinyint(1) NOT NULL COMMENT '类型编码:1-3亚健康,4-12中医体质',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目内容',
  `options` json NOT NULL COMMENT '选项及分值(JSON格式)',
  `reverse_score` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否反向计分:0否1是(中医体质)',
  `weight` int NOT NULL COMMENT '权重(百分比)',
  `version` int NOT NULL COMMENT '版本号',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-草稿,1-生效,2-归档',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评估量表题目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of assessment_question
-- ----------------------------
INSERT INTO `assessment_question` VALUES (1, 1, 'PH1 BMI指数', '[{\"range\": \"18.5-24\", \"score\": 0}, {\"range\": \"24-28 或 =18.5\", \"score\": 10}, {\"range\": \">=28 或 <=18\", \"score\": 20}]', 0, 40, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (2, 1, 'PH2 血压（收缩压）', '[{\"range\": \"90-120\", \"score\": 0}, {\"range\": \"120-139 或 80-89\", \"score\": 10}, {\"range\": \">=140 或 <=90\", \"score\": 20}]', 0, 40, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (3, 1, 'PH3 空腹血糖', '[{\"range\": \"3.9-6.1\", \"score\": 0}, {\"range\": \"6.1-7.0\", \"score\": 15}, {\"range\": \">=7.0 或 <=3.9\", \"score\": 25}]', 0, 40, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (4, 1, 'PH4 血脂（总胆固醇）', '[{\"range\": \"<5.2\", \"score\": 0}, {\"range\": \"5.2-6.2\", \"score\": 10}, {\"range\": \">6.2\", \"score\": 20}]', 0, 40, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (5, 2, 'P1 您是否感到情绪低落或沮丧？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (6, 2, 'P2 您是否感到焦虑或紧张？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (7, 2, 'P3 您是否对日常活动失去兴趣？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (8, 2, 'P4 您是否感到疲劳或精力不足？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (9, 2, 'P5 您是否难以集中注意力？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (10, 3, 'L1 您平均每晚睡眠时长？', '[{\"score\": 0, \"option\": \">=7小时\"}, {\"score\": 10, \"option\": \"6-7小时\"}, {\"score\": 20, \"option\": \"<6小时\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (11, 3, 'L2 您每周运动频率？', '[{\"score\": 0, \"option\": \">=3次/周\"}, {\"score\": 10, \"option\": \"1-2次/周\"}, {\"score\": 20, \"option\": \"几乎不运动\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (12, 3, 'L3 您的饮食结构？', '[{\"score\": 0, \"option\": \"荤素均衡\"}, {\"score\": 10, \"option\": \"偏荤或偏素\"}, {\"score\": 20, \"option\": \"常吃外卖/快餐\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (13, 3, 'L4 您是否吸烟或饮酒？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 10, \"option\": \"偶尔\"}, {\"score\": 20, \"option\": \"经常\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (14, 3, 'L5 您每天的久坐时长（含工作）？', '[{\"score\": 0, \"option\": \"<4小时\"}, {\"score\": 10, \"option\": \"4-8小时\"}, {\"score\": 20, \"option\": \">8小时\"}]', 0, 30, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (15, 4, 'A1 您精力充沛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (16, 4, 'A2 您容易疲劳吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (17, 4, 'A3 您说话声音低弱无力吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (18, 4, 'A4 您感到闷闷不乐、情绪低沉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (19, 4, 'A5 您比一般人耐受不了寒冷吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (20, 4, 'A6 您能适应外界自然和社会环境的变化吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (21, 4, 'A7 您容易失眠吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (22, 4, 'A8 您容易忘事吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (23, 5, 'B1 您容易疲乏吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (24, 5, 'B2 您容易气短（呼吸短促）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (25, 5, 'B3 您容易心慌吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (26, 5, 'B4 您容易头晕或站起时晕眩吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (27, 5, 'B5 您比别人容易感冒吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (28, 5, 'B6 您喜欢安静、懒得说话吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (29, 5, 'B7 您说话声音低弱无力吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (30, 6, 'C1 您手脚发凉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (31, 6, 'C2 您胃脘部、背部或腰膝部怕冷吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (32, 6, 'C3 您感到怕冷、衣服比别人穿得多吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (33, 6, 'C4 您比一般人耐受不了寒冷？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (34, 6, 'C5 您比别人容易患感冒吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (35, 6, 'C6 您吃（喝）凉的东西会感到不舒服吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (36, 6, 'C7 您受凉或吃凉的东西后容易腹泻吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (37, 7, 'D1 您感到手脚心发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (38, 7, 'D2 您感觉身体、脸上发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (39, 7, 'D3 您皮肤或口唇干吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (40, 7, 'D4 您口唇的颜色比一般人红吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (41, 7, 'D5 您容易便秘或大便干燥吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (42, 7, 'D6 您面部两颧潮红或偏红吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (43, 7, 'D7 您感到眼睛干涩吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (44, 8, 'E1 您感到胸闷或腹部胀满吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (45, 8, 'E2 您感到身体沉重不轻松吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (46, 8, 'E3 您腹部肥满松软吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (47, 8, 'E4 您有额部油脂分泌多的现象吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (48, 8, 'E5 您上眼睑比别人肿吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (49, 8, 'E6 您嘴里有黏黏的感觉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (50, 8, 'E7 您平时痰多吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (51, 9, 'F1 您面部或鼻部有油腻感吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (52, 9, 'F2 您容易生痤疮或疮疖吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (53, 9, 'F3 您感到口苦或嘴里有异味吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (54, 9, 'F4 您大便黏滞不爽、有解不尽的感觉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (55, 9, 'F5 您小便时尿道有发热感、尿色浓吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (56, 9, 'F6 您带下色黄（女性）或阴囊潮湿（男性）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (57, 9, 'F7 您身重困倦、午后发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (58, 10, 'G1 您的皮肤在不知不觉中会出现青紫瘀斑吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (59, 10, 'G2 您两颧部有细微红丝吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (60, 10, 'G3 您身体上有哪里疼痛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (61, 10, 'G4 您面色晦暗或容易出现褐斑吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (62, 10, 'G5 您容易有黑眼圈吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (63, 10, 'G6 您容易忘事吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (64, 10, 'G7 您口唇颜色偏暗吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (65, 11, 'H1 您感到闷闷不乐、情绪低沉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (66, 11, 'H2 您容易精神紧张、焦虑不安吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (67, 11, 'H3 您多愁善感、感情脆弱吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (68, 11, 'H4 您容易感到害怕或受到惊吓吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (69, 11, 'H5 您胁肋部或乳房胀痛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (70, 11, 'H6 您无缘无故叹气吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (71, 11, 'H7 您咽喉部有异物感吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (72, 12, 'I1 您没有感冒时也会打喷嚏吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (73, 12, 'I2 您没有感冒时也会鼻塞、流鼻涕吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (74, 12, 'I3 您有因季节变化、温度变化或异味而咳喘的现象吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (75, 12, 'I4 您容易过敏（药物、食物、花粉等）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (76, 12, 'I5 您的皮肤容易起荨麻疹吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (77, 12, 'I6 您的皮肤因过敏出现过紫癜吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `assessment_question` VALUES (78, 12, 'I7 您的皮肤一抓就红、并出现抓痕吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, 15, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');

-- ----------------------------
-- Table structure for audit_record
-- ----------------------------
DROP TABLE IF EXISTS `audit_record`;
CREATE TABLE `audit_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `target_id` int NOT NULL COMMENT '目标ID(动态ID或评论ID)',
  `target_type` tinyint(1) NOT NULL COMMENT '目标类型:1-动态,2-评论',
  `admin_id` int NOT NULL COMMENT '管理员ID',
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型:通过/驳回/删除/屏蔽',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原因',
  `audit_time` datetime NOT NULL COMMENT '审核时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_admin_id`(`admin_id` ASC) USING BTREE,
  CONSTRAINT `fk_audit_record_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '审核记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of audit_record
-- ----------------------------
INSERT INTO `audit_record` VALUES (1, 106, 1, 2, 'approve', NULL, '2026-05-15 19:00:13', '2026-05-15 19:00:12');
INSERT INTO `audit_record` VALUES (2, 107, 1, 1, 'approve', NULL, '2026-05-18 00:45:53', '2026-05-18 00:45:53');
INSERT INTO `audit_record` VALUES (3, 108, 1, 1, 'approve', NULL, '2026-05-18 00:57:41', '2026-05-18 00:57:41');
INSERT INTO `audit_record` VALUES (4, 109, 1, 1, 'approve', NULL, '2026-05-18 01:03:38', '2026-05-18 01:03:37');

-- ----------------------------
-- Table structure for follow_relation
-- ----------------------------
DROP TABLE IF EXISTS `follow_relation`;
CREATE TABLE `follow_relation`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '关系ID',
  `user_id` int NOT NULL COMMENT '关注者ID',
  `follow_id` int NOT NULL COMMENT '被关注者ID',
  `create_time` datetime NOT NULL COMMENT '关注时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_follow`(`user_id` ASC, `follow_id` ASC) USING BTREE,
  INDEX `idx_follow_id`(`follow_id` ASC) USING BTREE,
  CONSTRAINT `fk_follow_target` FOREIGN KEY (`follow_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_follow_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '关注关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of follow_relation
-- ----------------------------
INSERT INTO `follow_relation` VALUES (1, 6, 79, '2026-05-15 19:09:21');
INSERT INTO `follow_relation` VALUES (2, 6, 103, '2026-05-15 19:09:22');
INSERT INTO `follow_relation` VALUES (3, 6, 104, '2026-05-15 19:09:23');

-- ----------------------------
-- Table structure for health_assessment
-- ----------------------------
DROP TABLE IF EXISTS `health_assessment`;
CREATE TABLE `health_assessment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评估ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `total_score` int NOT NULL COMMENT '总分(0-100)',
  `level` tinyint(1) NOT NULL COMMENT '亚健康等级:0-健康,1-轻度,2-中度,3-重度',
  `physiological_score` int NULL DEFAULT NULL COMMENT '生理维度得分',
  `psychological_score` int NULL DEFAULT NULL COMMENT '心理维度得分',
  `lifestyle_score` int NULL DEFAULT NULL COMMENT '生活习惯得分',
  `diagnosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '诊断说明',
  `constitution_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '中医体质类型',
  `regimen_plan_id` int NULL DEFAULT NULL COMMENT '调理方案ID',
  `assess_time` datetime NOT NULL COMMENT '评估时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_regimen_plan_id`(`regimen_plan_id` ASC) USING BTREE,
  CONSTRAINT `fk_health_assessment_plan` FOREIGN KEY (`regimen_plan_id`) REFERENCES `regimen_plan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_health_assessment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '健康评估表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of health_assessment
-- ----------------------------
INSERT INTO `health_assessment` VALUES (10, 6, 15, 0, 40, 35, 30, '综合评估：亚健康等级0，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (11, 7, 40, 1, 41, 36, 31, '综合评估：亚健康等级1，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (12, 8, 65, 2, 42, 37, 32, '综合评估：亚健康等级2，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (13, 9, 90, 3, 43, 38, 33, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (14, 10, 27, 0, 44, 39, 34, '综合评估：亚健康等级0，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-05 14:00:00', '2026-05-05 14:00:00', '2026-05-05 14:00:00');
INSERT INTO `health_assessment` VALUES (15, 11, 37, 1, 45, 40, 35, '综合评估：亚健康等级1，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (16, 12, 62, 2, 46, 41, 36, '综合评估：亚健康等级2，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (17, 13, 87, 3, 47, 42, 37, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (18, 14, 24, 0, 48, 43, 38, '综合评估：亚健康等级0，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (19, 15, 49, 1, 49, 44, 39, '综合评估：亚健康等级1，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (20, 16, 81, 3, 50, 45, 40, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-11 14:00:00', '2026-05-11 14:00:00', '2026-05-11 14:00:00');
INSERT INTO `health_assessment` VALUES (21, 17, 84, 3, 51, 46, 41, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-12 14:00:00', '2026-05-12 14:00:00', '2026-05-12 14:00:00');
INSERT INTO `health_assessment` VALUES (22, 18, 43, 1, 52, 47, 42, '综合评估：亚健康等级1，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-13 14:00:00', '2026-05-13 14:00:00', '2026-05-13 14:00:00');
INSERT INTO `health_assessment` VALUES (23, 19, 68, 2, 53, 48, 43, '综合评估：亚健康等级2，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-14 14:00:00', '2026-05-14 14:00:00', '2026-05-14 14:00:00');
INSERT INTO `health_assessment` VALUES (24, 20, 93, 3, 54, 49, 44, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-15 14:00:00', '2026-05-15 14:00:00', '2026-05-15 14:00:00');
INSERT INTO `health_assessment` VALUES (25, 21, 81, 3, 55, 50, 45, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-16 14:00:00', '2026-05-16 14:00:00', '2026-05-16 14:00:00');
INSERT INTO `health_assessment` VALUES (26, 22, 40, 1, 56, 51, 46, '综合评估：亚健康等级1，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-17 14:00:00', '2026-05-17 14:00:00', '2026-05-17 14:00:00');
INSERT INTO `health_assessment` VALUES (27, 23, 65, 2, 57, 52, 47, '综合评估：亚健康等级2，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-18 14:00:00', '2026-05-18 14:00:00', '2026-05-18 14:00:00');
INSERT INTO `health_assessment` VALUES (28, 24, 90, 3, 58, 53, 48, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-19 14:00:00', '2026-05-19 14:00:00', '2026-05-19 14:00:00');
INSERT INTO `health_assessment` VALUES (29, 25, 93, 3, 59, 54, 49, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-20 14:00:00', '2026-05-20 14:00:00', '2026-05-20 14:00:00');
INSERT INTO `health_assessment` VALUES (30, 26, 59, 2, 60, 55, 30, '综合评估：亚健康等级2，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (31, 27, 84, 3, 61, 56, 31, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (32, 28, 87, 3, 62, 57, 32, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (33, 29, 90, 3, 63, 58, 33, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (34, 30, 71, 2, 64, 59, 34, '综合评估：亚健康等级2，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-05 14:00:00', '2026-05-05 14:00:00', '2026-05-05 14:00:00');
INSERT INTO `health_assessment` VALUES (35, 31, 81, 3, 65, 35, 35, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (36, 32, 84, 3, 66, 36, 36, '综合评估：亚健康等级3，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (37, 33, 87, 3, 67, 37, 37, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (38, 34, 68, 2, 68, 38, 38, '综合评估：亚健康等级2，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (39, 35, 93, 3, 69, 39, 39, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (40, 36, 81, 3, 40, 40, 40, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-11 14:00:00', '2026-05-11 14:00:00', '2026-05-11 14:00:00');
INSERT INTO `health_assessment` VALUES (41, 37, 84, 3, 41, 41, 41, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-12 14:00:00', '2026-05-12 14:00:00', '2026-05-12 14:00:00');
INSERT INTO `health_assessment` VALUES (42, 38, 87, 3, 42, 42, 42, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-13 14:00:00', '2026-05-13 14:00:00', '2026-05-13 14:00:00');
INSERT INTO `health_assessment` VALUES (43, 39, 90, 3, 43, 43, 43, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-14 14:00:00', '2026-05-14 14:00:00', '2026-05-14 14:00:00');
INSERT INTO `health_assessment` VALUES (44, 40, 93, 3, 44, 44, 44, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-15 14:00:00', '2026-05-15 14:00:00', '2026-05-15 14:00:00');
INSERT INTO `health_assessment` VALUES (45, 41, 81, 3, 45, 45, 45, '综合评估：亚健康等级3，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-16 14:00:00', '2026-05-16 14:00:00', '2026-05-16 14:00:00');
INSERT INTO `health_assessment` VALUES (46, 42, 84, 3, 46, 46, 46, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-17 14:00:00', '2026-05-17 14:00:00', '2026-05-17 14:00:00');
INSERT INTO `health_assessment` VALUES (47, 43, 87, 3, 47, 47, 47, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-18 14:00:00', '2026-05-18 14:00:00', '2026-05-18 14:00:00');
INSERT INTO `health_assessment` VALUES (48, 44, 90, 3, 48, 48, 48, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-19 14:00:00', '2026-05-19 14:00:00', '2026-05-19 14:00:00');
INSERT INTO `health_assessment` VALUES (49, 45, 93, 3, 49, 49, 49, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-20 14:00:00', '2026-05-20 14:00:00', '2026-05-20 14:00:00');
INSERT INTO `health_assessment` VALUES (50, 46, 81, 3, 50, 50, 30, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (51, 47, 84, 3, 51, 51, 31, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (52, 48, 87, 3, 52, 52, 32, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (53, 49, 90, 3, 53, 53, 33, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (54, 50, 93, 3, 54, 54, 34, '综合评估：亚健康等级3，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-05 14:00:00', '2026-05-05 14:00:00', '2026-05-05 14:00:00');
INSERT INTO `health_assessment` VALUES (55, 51, 81, 3, 55, 55, 35, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (56, 52, 84, 3, 56, 56, 36, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (57, 53, 87, 3, 57, 57, 37, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (58, 54, 90, 3, 58, 58, 38, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (59, 55, 93, 3, 59, 59, 39, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (60, 56, 15, 0, 40, 35, 30, '综合评估：亚健康等级0，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (61, 57, 40, 1, 41, 36, 31, '综合评估：亚健康等级1，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (62, 58, 65, 2, 42, 37, 32, '综合评估：亚健康等级2，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (63, 59, 90, 3, 43, 38, 33, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (64, 60, 27, 0, 44, 39, 34, '综合评估：亚健康等级0，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-05 14:00:00', '2026-05-05 14:00:00', '2026-05-05 14:00:00');
INSERT INTO `health_assessment` VALUES (65, 61, 37, 1, 45, 40, 35, '综合评估：亚健康等级1，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (66, 62, 62, 2, 46, 41, 36, '综合评估：亚健康等级2，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (67, 63, 87, 3, 47, 42, 37, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (68, 64, 24, 0, 48, 43, 38, '综合评估：亚健康等级0，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (69, 65, 49, 1, 49, 44, 39, '综合评估：亚健康等级1，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (70, 66, 81, 3, 50, 45, 40, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-11 14:00:00', '2026-05-11 14:00:00', '2026-05-11 14:00:00');
INSERT INTO `health_assessment` VALUES (71, 67, 84, 3, 51, 46, 41, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-12 14:00:00', '2026-05-12 14:00:00', '2026-05-12 14:00:00');
INSERT INTO `health_assessment` VALUES (72, 68, 43, 1, 52, 47, 42, '综合评估：亚健康等级1，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-13 14:00:00', '2026-05-13 14:00:00', '2026-05-13 14:00:00');
INSERT INTO `health_assessment` VALUES (73, 69, 68, 2, 53, 48, 43, '综合评估：亚健康等级2，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-14 14:00:00', '2026-05-14 14:00:00', '2026-05-14 14:00:00');
INSERT INTO `health_assessment` VALUES (74, 70, 93, 3, 54, 49, 44, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-15 14:00:00', '2026-05-15 14:00:00', '2026-05-15 14:00:00');
INSERT INTO `health_assessment` VALUES (75, 71, 81, 3, 55, 50, 45, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-16 14:00:00', '2026-05-16 14:00:00', '2026-05-16 14:00:00');
INSERT INTO `health_assessment` VALUES (76, 72, 40, 1, 56, 51, 46, '综合评估：亚健康等级1，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-17 14:00:00', '2026-05-17 14:00:00', '2026-05-17 14:00:00');
INSERT INTO `health_assessment` VALUES (77, 73, 65, 2, 57, 52, 47, '综合评估：亚健康等级2，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-18 14:00:00', '2026-05-18 14:00:00', '2026-05-18 14:00:00');
INSERT INTO `health_assessment` VALUES (78, 74, 90, 3, 58, 53, 48, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-19 14:00:00', '2026-05-19 14:00:00', '2026-05-19 14:00:00');
INSERT INTO `health_assessment` VALUES (79, 75, 93, 3, 59, 54, 49, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-20 14:00:00', '2026-05-20 14:00:00', '2026-05-20 14:00:00');
INSERT INTO `health_assessment` VALUES (80, 76, 59, 2, 60, 55, 30, '综合评估：亚健康等级2，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (81, 77, 84, 3, 61, 56, 31, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (82, 78, 87, 3, 62, 57, 32, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (83, 79, 90, 3, 63, 58, 33, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (84, 80, 71, 2, 64, 59, 34, '综合评估：亚健康等级2，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-05 14:00:00', '2026-05-05 14:00:00', '2026-05-05 14:00:00');
INSERT INTO `health_assessment` VALUES (85, 81, 81, 3, 65, 35, 35, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (86, 82, 84, 3, 66, 36, 36, '综合评估：亚健康等级3，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (87, 83, 87, 3, 67, 37, 37, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (88, 84, 68, 2, 68, 38, 38, '综合评估：亚健康等级2，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (89, 85, 93, 3, 69, 39, 39, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (90, 86, 81, 3, 40, 40, 40, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-11 14:00:00', '2026-05-11 14:00:00', '2026-05-11 14:00:00');
INSERT INTO `health_assessment` VALUES (91, 87, 84, 3, 41, 41, 41, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-12 14:00:00', '2026-05-12 14:00:00', '2026-05-12 14:00:00');
INSERT INTO `health_assessment` VALUES (92, 88, 87, 3, 42, 42, 42, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-13 14:00:00', '2026-05-13 14:00:00', '2026-05-13 14:00:00');
INSERT INTO `health_assessment` VALUES (93, 89, 90, 3, 43, 43, 43, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-14 14:00:00', '2026-05-14 14:00:00', '2026-05-14 14:00:00');
INSERT INTO `health_assessment` VALUES (94, 90, 93, 3, 44, 44, 44, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-15 14:00:00', '2026-05-15 14:00:00', '2026-05-15 14:00:00');
INSERT INTO `health_assessment` VALUES (95, 91, 81, 3, 45, 45, 45, '综合评估：亚健康等级3，体质特禀质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '特禀质', 3, '2026-05-16 14:00:00', '2026-05-16 14:00:00', '2026-05-16 14:00:00');
INSERT INTO `health_assessment` VALUES (96, 92, 84, 3, 46, 46, 46, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-17 14:00:00', '2026-05-17 14:00:00', '2026-05-17 14:00:00');
INSERT INTO `health_assessment` VALUES (97, 93, 87, 3, 47, 47, 47, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-18 14:00:00', '2026-05-18 14:00:00', '2026-05-18 14:00:00');
INSERT INTO `health_assessment` VALUES (98, 94, 90, 3, 48, 48, 48, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-19 14:00:00', '2026-05-19 14:00:00', '2026-05-19 14:00:00');
INSERT INTO `health_assessment` VALUES (99, 95, 93, 3, 49, 49, 49, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-20 14:00:00', '2026-05-20 14:00:00', '2026-05-20 14:00:00');
INSERT INTO `health_assessment` VALUES (100, 96, 81, 3, 50, 50, 30, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-01 14:00:00', '2026-05-01 14:00:00', '2026-05-01 14:00:00');
INSERT INTO `health_assessment` VALUES (101, 97, 84, 3, 51, 51, 31, '综合评估：亚健康等级3，体质湿热质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '湿热质', 3, '2026-05-02 14:00:00', '2026-05-02 14:00:00', '2026-05-02 14:00:00');
INSERT INTO `health_assessment` VALUES (102, 98, 87, 3, 52, 52, 32, '综合评估：亚健康等级3，体质血瘀质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '血瘀质', 1, '2026-05-03 14:00:00', '2026-05-03 14:00:00', '2026-05-03 14:00:00');
INSERT INTO `health_assessment` VALUES (103, 99, 90, 3, 53, 53, 33, '综合评估：亚健康等级3，体质气郁质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气郁质', 2, '2026-05-04 14:00:00', '2026-05-04 14:00:00', '2026-05-04 14:00:00');
INSERT INTO `health_assessment` VALUES (105, 101, 81, 3, 55, 55, 35, '综合评估：亚健康等级3，体质平和质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '平和质', 1, '2026-05-06 14:00:00', '2026-05-06 14:00:00', '2026-05-06 14:00:00');
INSERT INTO `health_assessment` VALUES (106, 102, 84, 3, 56, 56, 36, '综合评估：亚健康等级3，体质气虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '气虚质', 2, '2026-05-07 14:00:00', '2026-05-07 14:00:00', '2026-05-07 14:00:00');
INSERT INTO `health_assessment` VALUES (107, 103, 87, 3, 57, 57, 37, '综合评估：亚健康等级3，体质阳虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=3。', '阳虚质', 3, '2026-05-08 14:00:00', '2026-05-08 14:00:00', '2026-05-08 14:00:00');
INSERT INTO `health_assessment` VALUES (108, 104, 90, 3, 58, 58, 38, '综合评估：亚健康等级3，体质阴虚质，已匹配药膳穴位运动调理方案，regimen_plan_id=1。', '阴虚质', 1, '2026-05-09 14:00:00', '2026-05-09 14:00:00', '2026-05-09 14:00:00');
INSERT INTO `health_assessment` VALUES (109, 105, 93, 3, 59, 59, 39, '综合评估：亚健康等级3，体质痰湿质，已匹配药膳穴位运动调理方案，regimen_plan_id=2。', '痰湿质', 2, '2026-05-10 14:00:00', '2026-05-10 14:00:00', '2026-05-10 14:00:00');
INSERT INTO `health_assessment` VALUES (119, 106, 70, 3, 35, 85, 100, '综合得分 70（生理风险度 35、心理 85、生活习惯 100，满分100分越高越需关注）。判定为重度亚健康，建议及时就医并严格遵循调理方案。', '平和质', 1, '2026-05-19 10:37:23', '2026-05-19 10:37:23', '2026-05-19 10:37:23');
INSERT INTO `health_assessment` VALUES (120, 106, 0, 0, NULL, NULL, NULL, '已完成体质辨识，请继续亚健康问卷评估', '痰湿质', 1, '2026-05-19 10:38:52', '2026-05-19 10:38:52', '2026-05-19 10:38:52');

-- ----------------------------
-- Table structure for health_data
-- ----------------------------
DROP TABLE IF EXISTS `health_data`;
CREATE TABLE `health_data`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '数据ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `data_type` tinyint NOT NULL COMMENT '数据类型:1-身高体重,2-血压,3-血糖,4-血脂',
  `height` decimal(5, 2) NULL DEFAULT NULL COMMENT '身高(cm)',
  `weight` decimal(5, 2) NULL DEFAULT NULL COMMENT '体重(kg)',
  `systolic` int NULL DEFAULT NULL COMMENT '收缩压(mmHg)',
  `diastolic` int NULL DEFAULT NULL COMMENT '舒张压(mmHg)',
  `fasting_glucose` decimal(4, 2) NULL DEFAULT NULL COMMENT '空腹血糖(mmol/L)',
  `total_cholesterol` decimal(4, 2) NULL DEFAULT NULL COMMENT '总胆固醇(mmol/L)',
  `record_time` datetime NOT NULL COMMENT '记录时间',
  `is_abnormal` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否异常:0-正常,1-异常',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_health_data_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2075 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '健康数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of health_data
-- ----------------------------
INSERT INTO `health_data` VALUES (5, 7, 1, 161.00, 82.90, NULL, NULL, NULL, NULL, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (6, 7, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-04 09:00:00', 0, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (7, 7, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (8, 7, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (9, 8, 1, 162.00, 84.00, NULL, NULL, NULL, NULL, '2026-04-05 09:00:00', 1, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (10, 8, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (11, 8, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (12, 8, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (13, 9, 1, 163.00, 85.00, NULL, NULL, NULL, NULL, '2026-04-06 09:00:00', 1, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (14, 9, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (15, 9, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (16, 9, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (17, 10, 1, 164.00, 86.10, NULL, NULL, NULL, NULL, '2026-04-07 09:00:00', 1, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (18, 10, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (19, 10, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (20, 10, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (21, 11, 1, 165.00, 87.10, NULL, NULL, NULL, NULL, '2026-04-08 09:00:00', 1, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (22, 11, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-08 09:00:00', 0, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (23, 11, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-08 09:00:00', 0, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (24, 11, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-08 09:00:00', 1, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (25, 12, 1, 166.00, 88.20, NULL, NULL, NULL, NULL, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (26, 12, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-09 09:00:00', 0, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (27, 12, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (28, 12, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (29, 13, 1, 167.00, 89.20, NULL, NULL, NULL, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (30, 13, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (31, 13, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (32, 13, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-10 09:00:00', 0, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (33, 14, 1, 168.00, 48.00, NULL, NULL, NULL, NULL, '2026-04-11 09:00:00', 1, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (34, 14, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (35, 14, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (36, 14, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (37, 15, 1, 160.00, 43.50, NULL, NULL, NULL, NULL, '2026-04-12 09:00:00', 1, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (38, 15, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (39, 15, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (40, 15, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (41, 16, 1, 161.00, 44.10, NULL, NULL, NULL, NULL, '2026-04-13 09:00:00', 1, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (42, 16, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-13 09:00:00', 0, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (43, 16, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-13 09:00:00', 0, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (44, 16, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-13 09:00:00', 1, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (45, 17, 1, 162.00, 44.60, NULL, NULL, NULL, NULL, '2026-04-14 09:00:00', 1, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (46, 17, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-14 09:00:00', 0, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (47, 17, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-14 09:00:00', 0, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (48, 17, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-14 09:00:00', 1, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (49, 18, 1, 163.00, 45.20, NULL, NULL, NULL, NULL, '2026-04-15 09:00:00', 1, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (50, 18, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-15 09:00:00', 0, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (51, 18, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-15 09:00:00', 1, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (52, 18, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-15 09:00:00', 0, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (53, 19, 1, 164.00, 45.70, NULL, NULL, NULL, NULL, '2026-04-16 09:00:00', 1, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (54, 19, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-16 09:00:00', 0, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (55, 19, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-16 09:00:00', 1, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (56, 19, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-16 09:00:00', 0, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (57, 20, 1, 165.00, 46.30, NULL, NULL, NULL, NULL, '2026-04-17 09:00:00', 1, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (58, 20, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-17 09:00:00', 1, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (59, 20, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-17 09:00:00', 0, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (60, 20, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-17 09:00:00', 0, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (61, 21, 1, 166.00, 46.80, NULL, NULL, NULL, NULL, '2026-04-18 09:00:00', 1, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (62, 21, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-18 09:00:00', 0, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (63, 21, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-18 09:00:00', 0, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (64, 21, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-18 09:00:00', 1, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (65, 22, 1, 167.00, 72.50, NULL, NULL, NULL, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (66, 22, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (67, 22, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (68, 22, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-19 09:00:00', 1, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (69, 23, 1, 168.00, 73.40, NULL, NULL, NULL, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (70, 23, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (71, 23, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (72, 23, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (73, 24, 1, 160.00, 66.60, NULL, NULL, NULL, NULL, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (74, 24, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (75, 24, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-21 09:00:00', 1, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (76, 24, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (77, 25, 1, 161.00, 67.40, NULL, NULL, NULL, NULL, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (78, 25, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (79, 25, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-22 09:00:00', 1, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (80, 25, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (81, 26, 1, 162.00, 68.20, NULL, NULL, NULL, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (82, 26, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (83, 26, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (84, 26, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-23 09:00:00', 1, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (85, 27, 1, 163.00, 69.10, NULL, NULL, NULL, NULL, '2026-04-24 09:00:00', 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (86, 27, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-24 09:00:00', 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (87, 27, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-24 09:00:00', 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (88, 27, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-24 09:00:00', 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (89, 28, 1, 164.00, 69.90, NULL, NULL, NULL, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (90, 28, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (91, 28, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (92, 28, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (93, 29, 1, 165.00, 70.80, NULL, NULL, NULL, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (94, 29, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (95, 29, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (96, 29, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (97, 30, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (98, 30, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (99, 30, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-27 09:00:00', 1, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (100, 30, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (101, 31, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (102, 31, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (103, 31, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (104, 31, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (105, 32, 1, 168.00, 59.30, NULL, NULL, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (106, 32, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (107, 32, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (108, 32, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-07 09:00:00', 1, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (109, 33, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (110, 33, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (111, 33, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (112, 33, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (113, 34, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (114, 34, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-09 09:00:00', 1, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (115, 34, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (116, 34, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (117, 35, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (118, 35, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (119, 35, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (120, 35, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (121, 36, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-11 09:00:00', 0, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (122, 36, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-11 09:00:00', 0, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (123, 36, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-11 09:00:00', 1, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (124, 36, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-11 09:00:00', 1, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (125, 37, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-12 09:00:00', 0, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (126, 37, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-12 09:00:00', 0, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (127, 37, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-12 09:00:00', 1, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (128, 37, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-12 09:00:00', 1, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (129, 38, 1, 165.00, 57.20, NULL, NULL, NULL, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (130, 38, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (131, 38, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (132, 38, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (133, 39, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (134, 39, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (135, 39, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (136, 39, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (137, 40, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (138, 40, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (139, 40, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (140, 40, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (141, 41, 1, 168.00, 59.30, NULL, NULL, NULL, NULL, '2026-05-16 09:00:00', 0, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (142, 41, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-16 09:00:00', 1, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (143, 41, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-16 09:00:00', 0, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (144, 41, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-16 09:00:00', 1, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (145, 42, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-17 09:00:00', 0, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (146, 42, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-17 09:00:00', 0, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (147, 42, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-17 09:00:00', 1, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (148, 42, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-17 09:00:00', 1, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (149, 43, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (150, 43, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (151, 43, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-18 09:00:00', 1, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (152, 43, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (153, 44, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (154, 44, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (155, 44, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (156, 44, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (157, 45, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (158, 45, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (159, 45, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (160, 45, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (161, 46, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (162, 46, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (163, 46, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (164, 46, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-01 09:00:00', 1, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (165, 47, 1, 165.00, 57.20, NULL, NULL, NULL, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (166, 47, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (167, 47, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (168, 47, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-02 09:00:00', 1, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (169, 48, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-05-03 09:00:00', 0, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (170, 48, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-03 09:00:00', 1, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (171, 48, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-03 09:00:00', 1, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (172, 48, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-03 09:00:00', 0, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (173, 49, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (174, 49, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (175, 49, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-04 09:00:00', 1, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (176, 49, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (177, 50, 1, 168.00, 59.30, NULL, NULL, NULL, NULL, '2026-05-05 09:00:00', 0, '2026-05-05 09:00:00', '2026-05-05 09:00:00');
INSERT INTO `health_data` VALUES (178, 50, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-05 09:00:00', 0, '2026-05-05 09:00:00', '2026-05-05 09:00:00');
INSERT INTO `health_data` VALUES (179, 50, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-05 09:00:00', 0, '2026-05-05 09:00:00', '2026-05-05 09:00:00');
INSERT INTO `health_data` VALUES (180, 50, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-05 09:00:00', 0, '2026-05-05 09:00:00', '2026-05-05 09:00:00');
INSERT INTO `health_data` VALUES (181, 51, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (182, 51, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (183, 51, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (184, 51, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (185, 52, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (186, 52, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (187, 52, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (188, 52, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-07 09:00:00', 1, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (189, 53, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (190, 53, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (191, 53, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (192, 53, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (193, 54, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (194, 54, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (195, 54, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-09 09:00:00', 1, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (196, 54, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (197, 55, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (198, 55, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-10 09:00:00', 1, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (199, 55, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-10 09:00:00', 1, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (200, 55, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (201, 56, 1, 160.00, 81.90, NULL, NULL, NULL, NULL, '2026-04-03 09:00:00', 1, '2026-04-03 09:00:00', '2026-04-03 09:00:00');
INSERT INTO `health_data` VALUES (202, 56, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-03 09:00:00', 1, '2026-04-03 09:00:00', '2026-04-03 09:00:00');
INSERT INTO `health_data` VALUES (203, 56, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-03 09:00:00', 1, '2026-04-03 09:00:00', '2026-04-03 09:00:00');
INSERT INTO `health_data` VALUES (204, 56, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-03 09:00:00', 1, '2026-04-03 09:00:00', '2026-04-03 09:00:00');
INSERT INTO `health_data` VALUES (205, 57, 1, 161.00, 82.90, NULL, NULL, NULL, NULL, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (206, 57, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-04 09:00:00', 0, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (207, 57, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (208, 57, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-04 09:00:00', 1, '2026-04-04 09:00:00', '2026-04-04 09:00:00');
INSERT INTO `health_data` VALUES (209, 58, 1, 162.00, 84.00, NULL, NULL, NULL, NULL, '2026-04-05 09:00:00', 1, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (210, 58, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (211, 58, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (212, 58, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-05 09:00:00', 0, '2026-04-05 09:00:00', '2026-04-05 09:00:00');
INSERT INTO `health_data` VALUES (213, 59, 1, 163.00, 85.00, NULL, NULL, NULL, NULL, '2026-04-06 09:00:00', 1, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (214, 59, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (215, 59, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (216, 59, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-06 09:00:00', 0, '2026-04-06 09:00:00', '2026-04-06 09:00:00');
INSERT INTO `health_data` VALUES (217, 60, 1, 164.00, 86.10, NULL, NULL, NULL, NULL, '2026-04-07 09:00:00', 1, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (218, 60, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (219, 60, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (220, 60, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-07 09:00:00', 0, '2026-04-07 09:00:00', '2026-04-07 09:00:00');
INSERT INTO `health_data` VALUES (221, 61, 1, 165.00, 87.10, NULL, NULL, NULL, NULL, '2026-04-08 09:00:00', 1, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (222, 61, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-08 09:00:00', 0, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (223, 61, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-08 09:00:00', 0, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (224, 61, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-08 09:00:00', 1, '2026-04-08 09:00:00', '2026-04-08 09:00:00');
INSERT INTO `health_data` VALUES (225, 62, 1, 166.00, 88.20, NULL, NULL, NULL, NULL, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (226, 62, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-09 09:00:00', 0, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (227, 62, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (228, 62, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-09 09:00:00', 1, '2026-04-09 09:00:00', '2026-04-09 09:00:00');
INSERT INTO `health_data` VALUES (229, 63, 1, 167.00, 89.20, NULL, NULL, NULL, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (230, 63, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (231, 63, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-10 09:00:00', 1, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (232, 63, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-10 09:00:00', 0, '2026-04-10 09:00:00', '2026-04-10 09:00:00');
INSERT INTO `health_data` VALUES (233, 64, 1, 168.00, 48.00, NULL, NULL, NULL, NULL, '2026-04-11 09:00:00', 1, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (234, 64, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (235, 64, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (236, 64, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-11 09:00:00', 0, '2026-04-11 09:00:00', '2026-04-11 09:00:00');
INSERT INTO `health_data` VALUES (237, 65, 1, 160.00, 43.50, NULL, NULL, NULL, NULL, '2026-04-12 09:00:00', 1, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (238, 65, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (239, 65, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (240, 65, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-12 09:00:00', 0, '2026-04-12 09:00:00', '2026-04-12 09:00:00');
INSERT INTO `health_data` VALUES (241, 66, 1, 161.00, 44.10, NULL, NULL, NULL, NULL, '2026-04-13 09:00:00', 1, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (242, 66, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-13 09:00:00', 0, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (243, 66, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-13 09:00:00', 0, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (244, 66, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-13 09:00:00', 1, '2026-04-13 09:00:00', '2026-04-13 09:00:00');
INSERT INTO `health_data` VALUES (245, 67, 1, 162.00, 44.60, NULL, NULL, NULL, NULL, '2026-04-14 09:00:00', 1, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (246, 67, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-14 09:00:00', 0, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (247, 67, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-14 09:00:00', 0, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (248, 67, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-14 09:00:00', 1, '2026-04-14 09:00:00', '2026-04-14 09:00:00');
INSERT INTO `health_data` VALUES (249, 68, 1, 163.00, 45.20, NULL, NULL, NULL, NULL, '2026-04-15 09:00:00', 1, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (250, 68, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-15 09:00:00', 0, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (251, 68, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-15 09:00:00', 1, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (252, 68, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-15 09:00:00', 0, '2026-04-15 09:00:00', '2026-04-15 09:00:00');
INSERT INTO `health_data` VALUES (253, 69, 1, 164.00, 45.70, NULL, NULL, NULL, NULL, '2026-04-16 09:00:00', 1, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (254, 69, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-16 09:00:00', 0, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (255, 69, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-16 09:00:00', 1, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (256, 69, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-16 09:00:00', 0, '2026-04-16 09:00:00', '2026-04-16 09:00:00');
INSERT INTO `health_data` VALUES (257, 70, 1, 165.00, 46.30, NULL, NULL, NULL, NULL, '2026-04-17 09:00:00', 1, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (258, 70, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-17 09:00:00', 1, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (259, 70, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-17 09:00:00', 0, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (260, 70, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-17 09:00:00', 0, '2026-04-17 09:00:00', '2026-04-17 09:00:00');
INSERT INTO `health_data` VALUES (261, 71, 1, 166.00, 46.80, NULL, NULL, NULL, NULL, '2026-04-18 09:00:00', 1, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (262, 71, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-18 09:00:00', 0, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (263, 71, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-18 09:00:00', 0, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (264, 71, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-18 09:00:00', 1, '2026-04-18 09:00:00', '2026-04-18 09:00:00');
INSERT INTO `health_data` VALUES (265, 72, 1, 167.00, 72.50, NULL, NULL, NULL, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (266, 72, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (267, 72, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-19 09:00:00', 0, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (268, 72, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-19 09:00:00', 1, '2026-04-19 09:00:00', '2026-04-19 09:00:00');
INSERT INTO `health_data` VALUES (269, 73, 1, 168.00, 73.40, NULL, NULL, NULL, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (270, 73, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (271, 73, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (272, 73, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-20 09:00:00', 0, '2026-04-20 09:00:00', '2026-04-20 09:00:00');
INSERT INTO `health_data` VALUES (273, 74, 1, 160.00, 66.60, NULL, NULL, NULL, NULL, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (274, 74, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (275, 74, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-21 09:00:00', 1, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (276, 74, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-21 09:00:00', 0, '2026-04-21 09:00:00', '2026-04-21 09:00:00');
INSERT INTO `health_data` VALUES (277, 75, 1, 161.00, 67.40, NULL, NULL, NULL, NULL, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (278, 75, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (279, 75, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-04-22 09:00:00', 1, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (280, 75, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-22 09:00:00', 0, '2026-04-22 09:00:00', '2026-04-22 09:00:00');
INSERT INTO `health_data` VALUES (281, 76, 1, 162.00, 68.20, NULL, NULL, NULL, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (282, 76, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (283, 76, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-23 09:00:00', 0, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (284, 76, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-04-23 09:00:00', 1, '2026-04-23 09:00:00', '2026-04-23 09:00:00');
INSERT INTO `health_data` VALUES (285, 77, 1, 163.00, 69.10, NULL, NULL, NULL, NULL, '2026-04-24 09:00:00', 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (286, 77, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-04-24 09:00:00', 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (287, 77, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-24 09:00:00', 0, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (288, 77, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-04-24 09:00:00', 1, '2026-04-24 09:00:00', '2026-04-24 09:00:00');
INSERT INTO `health_data` VALUES (289, 78, 1, 164.00, 69.90, NULL, NULL, NULL, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (290, 78, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (291, 78, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (292, 78, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-25 09:00:00', 0, '2026-04-25 09:00:00', '2026-04-25 09:00:00');
INSERT INTO `health_data` VALUES (293, 79, 1, 165.00, 70.80, NULL, NULL, NULL, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (294, 79, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (295, 79, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (296, 79, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-26 09:00:00', 0, '2026-04-26 09:00:00', '2026-04-26 09:00:00');
INSERT INTO `health_data` VALUES (297, 80, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (298, 80, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (299, 80, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-04-27 09:00:00', 1, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (300, 80, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-04-27 09:00:00', 0, '2026-04-27 09:00:00', '2026-04-27 09:00:00');
INSERT INTO `health_data` VALUES (301, 81, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (302, 81, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (303, 81, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (304, 81, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (305, 82, 1, 168.00, 59.30, NULL, NULL, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (306, 82, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (307, 82, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (308, 82, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-07 09:00:00', 1, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (309, 83, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (310, 83, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (311, 83, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (312, 83, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (313, 84, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (314, 84, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-09 09:00:00', 1, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (315, 84, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (316, 84, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (317, 85, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (318, 85, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (319, 85, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (320, 85, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (321, 86, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-11 09:00:00', 0, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (322, 86, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-11 09:00:00', 0, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (323, 86, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-11 09:00:00', 1, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (324, 86, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-11 09:00:00', 1, '2026-05-11 09:00:00', '2026-05-11 09:00:00');
INSERT INTO `health_data` VALUES (325, 87, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-12 09:00:00', 0, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (326, 87, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-12 09:00:00', 0, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (327, 87, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-12 09:00:00', 1, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (328, 87, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-12 09:00:00', 1, '2026-05-12 09:00:00', '2026-05-12 09:00:00');
INSERT INTO `health_data` VALUES (329, 88, 1, 165.00, 57.20, NULL, NULL, NULL, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (330, 88, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (331, 88, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (332, 88, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-13 09:00:00', 0, '2026-05-13 09:00:00', '2026-05-13 09:00:00');
INSERT INTO `health_data` VALUES (333, 89, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (334, 89, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (335, 89, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (336, 89, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-14 09:00:00', 0, '2026-05-14 09:00:00', '2026-05-14 09:00:00');
INSERT INTO `health_data` VALUES (337, 90, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (338, 90, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (339, 90, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (340, 90, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-15 09:00:00', 0, '2026-05-15 09:00:00', '2026-05-15 09:00:00');
INSERT INTO `health_data` VALUES (341, 91, 1, 168.00, 59.30, NULL, NULL, NULL, NULL, '2026-05-16 09:00:00', 0, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (342, 91, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-16 09:00:00', 1, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (343, 91, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-16 09:00:00', 0, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (344, 91, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-16 09:00:00', 1, '2026-05-16 09:00:00', '2026-05-16 09:00:00');
INSERT INTO `health_data` VALUES (345, 92, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-17 09:00:00', 0, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (346, 92, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-17 09:00:00', 0, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (347, 92, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-17 09:00:00', 1, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (348, 92, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-17 09:00:00', 1, '2026-05-17 09:00:00', '2026-05-17 09:00:00');
INSERT INTO `health_data` VALUES (349, 93, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (350, 93, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (351, 93, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-18 09:00:00', 1, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (352, 93, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-18 09:00:00', 0, '2026-05-18 09:00:00', '2026-05-18 09:00:00');
INSERT INTO `health_data` VALUES (353, 94, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (354, 94, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (355, 94, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (356, 94, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-19 09:00:00', 0, '2026-05-19 09:00:00', '2026-05-19 09:00:00');
INSERT INTO `health_data` VALUES (357, 95, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (358, 95, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (359, 95, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (360, 95, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-20 09:00:00', 0, '2026-05-20 09:00:00', '2026-05-20 09:00:00');
INSERT INTO `health_data` VALUES (361, 96, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (362, 96, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (363, 96, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-01 09:00:00', 0, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (364, 96, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-01 09:00:00', 1, '2026-05-01 09:00:00', '2026-05-01 09:00:00');
INSERT INTO `health_data` VALUES (365, 97, 1, 165.00, 57.20, NULL, NULL, NULL, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (366, 97, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (367, 97, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-02 09:00:00', 0, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (368, 97, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-02 09:00:00', 1, '2026-05-02 09:00:00', '2026-05-02 09:00:00');
INSERT INTO `health_data` VALUES (369, 98, 1, 166.00, 57.90, NULL, NULL, NULL, NULL, '2026-05-03 09:00:00', 0, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (370, 98, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-03 09:00:00', 1, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (371, 98, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-03 09:00:00', 1, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (372, 98, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-03 09:00:00', 0, '2026-05-03 09:00:00', '2026-05-03 09:00:00');
INSERT INTO `health_data` VALUES (373, 99, 1, 167.00, 58.60, NULL, NULL, NULL, NULL, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (374, 99, 2, NULL, NULL, 92, 58, NULL, NULL, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (375, 99, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-04 09:00:00', 1, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (376, 99, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-04 09:00:00', 0, '2026-05-04 09:00:00', '2026-05-04 09:00:00');
INSERT INTO `health_data` VALUES (381, 101, 1, 160.00, 53.80, NULL, NULL, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (382, 101, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (383, 101, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-06 09:00:00', 0, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (384, 101, 4, NULL, NULL, NULL, NULL, NULL, 6.50, '2026-05-06 09:00:00', 1, '2026-05-06 09:00:00', '2026-05-06 09:00:00');
INSERT INTO `health_data` VALUES (385, 102, 1, 161.00, 54.40, NULL, NULL, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (386, 102, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (387, 102, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-07 09:00:00', 0, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (388, 102, 4, NULL, NULL, NULL, NULL, NULL, 3.80, '2026-05-07 09:00:00', 1, '2026-05-07 09:00:00', '2026-05-07 09:00:00');
INSERT INTO `health_data` VALUES (389, 103, 1, 162.00, 55.10, NULL, NULL, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (390, 103, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (391, 103, 3, NULL, NULL, NULL, NULL, 5.20, NULL, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (392, 103, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-08 09:00:00', 0, '2026-05-08 09:00:00', '2026-05-08 09:00:00');
INSERT INTO `health_data` VALUES (393, 104, 1, 163.00, 55.80, NULL, NULL, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (394, 104, 2, NULL, NULL, 118, 76, NULL, NULL, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (395, 104, 3, NULL, NULL, NULL, NULL, 7.80, NULL, '2026-05-09 09:00:00', 1, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (396, 104, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-09 09:00:00', 0, '2026-05-09 09:00:00', '2026-05-09 09:00:00');
INSERT INTO `health_data` VALUES (397, 105, 1, 164.00, 56.50, NULL, NULL, NULL, NULL, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (398, 105, 2, NULL, NULL, 148, 96, NULL, NULL, '2026-05-10 09:00:00', 1, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (399, 105, 3, NULL, NULL, NULL, NULL, 3.60, NULL, '2026-05-10 09:00:00', 1, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (400, 105, 4, NULL, NULL, NULL, NULL, NULL, 4.90, '2026-05-10 09:00:00', 0, '2026-05-10 09:00:00', '2026-05-10 09:00:00');
INSERT INTO `health_data` VALUES (421, 200, 1, 170.00, 88.00, NULL, NULL, NULL, NULL, '2026-03-01 09:30:00', 0, '2026-03-01 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (422, 200, 1, 170.00, 87.85, NULL, NULL, NULL, NULL, '2026-03-02 09:30:00', 0, '2026-03-02 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (423, 200, 1, 170.00, 87.71, NULL, NULL, NULL, NULL, '2026-03-03 09:30:00', 0, '2026-03-03 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (424, 200, 1, 170.00, 87.56, NULL, NULL, NULL, NULL, '2026-03-04 09:30:00', 0, '2026-03-04 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (425, 200, 1, 170.00, 87.41, NULL, NULL, NULL, NULL, '2026-03-05 09:30:00', 0, '2026-03-05 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (426, 200, 1, 170.00, 87.27, NULL, NULL, NULL, NULL, '2026-03-06 09:30:00', 0, '2026-03-06 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (427, 200, 1, 170.00, 87.12, NULL, NULL, NULL, NULL, '2026-03-07 09:30:00', 0, '2026-03-07 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (428, 200, 1, 170.00, 86.97, NULL, NULL, NULL, NULL, '2026-03-08 09:30:00', 0, '2026-03-08 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (429, 200, 1, 170.00, 86.83, NULL, NULL, NULL, NULL, '2026-03-09 09:30:00', 0, '2026-03-09 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (430, 200, 1, 170.00, 86.68, NULL, NULL, NULL, NULL, '2026-03-10 09:30:00', 0, '2026-03-10 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (431, 200, 1, 170.00, 86.53, NULL, NULL, NULL, NULL, '2026-03-11 09:30:00', 0, '2026-03-11 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (432, 200, 1, 170.00, 86.39, NULL, NULL, NULL, NULL, '2026-03-12 09:30:00', 0, '2026-03-12 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (433, 200, 1, 170.00, 86.24, NULL, NULL, NULL, NULL, '2026-03-13 09:30:00', 0, '2026-03-13 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (434, 200, 1, 170.00, 86.09, NULL, NULL, NULL, NULL, '2026-03-14 09:30:00', 0, '2026-03-14 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (435, 200, 1, 170.00, 85.95, NULL, NULL, NULL, NULL, '2026-03-15 09:30:00', 0, '2026-03-15 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (436, 200, 1, 170.00, 85.80, NULL, NULL, NULL, NULL, '2026-03-16 09:30:00', 0, '2026-03-16 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (437, 200, 1, 170.00, 85.65, NULL, NULL, NULL, NULL, '2026-03-17 09:30:00', 0, '2026-03-17 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (438, 200, 1, 170.00, 85.51, NULL, NULL, NULL, NULL, '2026-03-18 09:30:00', 0, '2026-03-18 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (439, 200, 1, 170.00, 85.36, NULL, NULL, NULL, NULL, '2026-03-19 09:30:00', 0, '2026-03-19 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (440, 200, 1, 170.00, 85.21, NULL, NULL, NULL, NULL, '2026-03-20 09:30:00', 0, '2026-03-20 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (441, 200, 1, 170.00, 85.07, NULL, NULL, NULL, NULL, '2026-03-21 09:30:00', 0, '2026-03-21 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (442, 200, 1, 170.00, 84.92, NULL, NULL, NULL, NULL, '2026-03-22 09:30:00', 0, '2026-03-22 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (443, 200, 1, 170.00, 84.77, NULL, NULL, NULL, NULL, '2026-03-23 09:30:00', 0, '2026-03-23 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (444, 200, 1, 170.00, 84.63, NULL, NULL, NULL, NULL, '2026-03-24 09:30:00', 0, '2026-03-24 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (445, 200, 1, 170.00, 84.48, NULL, NULL, NULL, NULL, '2026-03-25 09:30:00', 0, '2026-03-25 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (446, 200, 1, 170.00, 84.33, NULL, NULL, NULL, NULL, '2026-03-26 09:30:00', 0, '2026-03-26 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (447, 200, 1, 170.00, 84.19, NULL, NULL, NULL, NULL, '2026-03-27 09:30:00', 0, '2026-03-27 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (448, 200, 1, 170.00, 84.04, NULL, NULL, NULL, NULL, '2026-03-28 09:30:00', 0, '2026-03-28 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (449, 200, 1, 170.00, 83.89, NULL, NULL, NULL, NULL, '2026-03-29 09:30:00', 0, '2026-03-29 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (450, 200, 1, 170.00, 83.75, NULL, NULL, NULL, NULL, '2026-03-30 09:30:00', 0, '2026-03-30 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (451, 200, 1, 170.00, 83.60, NULL, NULL, NULL, NULL, '2026-03-31 09:30:00', 0, '2026-03-31 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (452, 200, 1, 170.00, 83.45, NULL, NULL, NULL, NULL, '2026-04-01 09:30:00', 0, '2026-04-01 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (453, 200, 1, 170.00, 83.31, NULL, NULL, NULL, NULL, '2026-04-02 09:30:00', 0, '2026-04-02 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (454, 200, 1, 170.00, 83.16, NULL, NULL, NULL, NULL, '2026-04-03 09:30:00', 0, '2026-04-03 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (455, 200, 1, 170.00, 83.01, NULL, NULL, NULL, NULL, '2026-04-04 09:30:00', 0, '2026-04-04 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (456, 200, 1, 170.00, 82.87, NULL, NULL, NULL, NULL, '2026-04-05 09:30:00', 0, '2026-04-05 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (457, 200, 1, 170.00, 82.72, NULL, NULL, NULL, NULL, '2026-04-06 09:30:00', 0, '2026-04-06 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (458, 200, 1, 170.00, 82.57, NULL, NULL, NULL, NULL, '2026-04-07 09:30:00', 0, '2026-04-07 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (459, 200, 1, 170.00, 82.43, NULL, NULL, NULL, NULL, '2026-04-08 09:30:00', 0, '2026-04-08 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (460, 200, 1, 170.00, 82.28, NULL, NULL, NULL, NULL, '2026-04-09 09:30:00', 0, '2026-04-09 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (461, 200, 1, 170.00, 82.13, NULL, NULL, NULL, NULL, '2026-04-10 09:30:00', 0, '2026-04-10 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (462, 200, 1, 170.00, 81.99, NULL, NULL, NULL, NULL, '2026-04-11 09:30:00', 0, '2026-04-11 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (463, 200, 1, 170.00, 81.84, NULL, NULL, NULL, NULL, '2026-04-12 09:30:00', 0, '2026-04-12 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (464, 200, 1, 170.00, 81.69, NULL, NULL, NULL, NULL, '2026-04-13 09:30:00', 0, '2026-04-13 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (465, 200, 1, 170.00, 81.55, NULL, NULL, NULL, NULL, '2026-04-14 09:30:00', 0, '2026-04-14 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (466, 200, 1, 170.00, 81.40, NULL, NULL, NULL, NULL, '2026-04-15 09:30:00', 0, '2026-04-15 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (467, 200, 1, 170.00, 81.25, NULL, NULL, NULL, NULL, '2026-04-16 09:30:00', 0, '2026-04-16 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (468, 200, 1, 170.00, 81.11, NULL, NULL, NULL, NULL, '2026-04-17 09:30:00', 0, '2026-04-17 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (469, 200, 1, 170.00, 80.96, NULL, NULL, NULL, NULL, '2026-04-18 09:30:00', 0, '2026-04-18 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (470, 200, 1, 170.00, 80.81, NULL, NULL, NULL, NULL, '2026-04-19 09:30:00', 0, '2026-04-19 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (471, 200, 1, 170.00, 80.67, NULL, NULL, NULL, NULL, '2026-04-20 09:30:00', 0, '2026-04-20 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (472, 200, 1, 170.00, 80.52, NULL, NULL, NULL, NULL, '2026-04-21 09:30:00', 0, '2026-04-21 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (473, 200, 1, 170.00, 80.37, NULL, NULL, NULL, NULL, '2026-04-22 09:30:00', 0, '2026-04-22 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (474, 200, 1, 170.00, 80.23, NULL, NULL, NULL, NULL, '2026-04-23 09:30:00', 0, '2026-04-23 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (475, 200, 1, 170.00, 80.08, NULL, NULL, NULL, NULL, '2026-04-24 09:30:00', 0, '2026-04-24 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (476, 200, 1, 170.00, 79.93, NULL, NULL, NULL, NULL, '2026-04-25 09:30:00', 0, '2026-04-25 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (477, 200, 1, 170.00, 79.79, NULL, NULL, NULL, NULL, '2026-04-26 09:30:00', 0, '2026-04-26 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (478, 200, 1, 170.00, 79.64, NULL, NULL, NULL, NULL, '2026-04-27 09:30:00', 0, '2026-04-27 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (479, 200, 1, 170.00, 79.49, NULL, NULL, NULL, NULL, '2026-04-28 09:30:00', 0, '2026-04-28 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (480, 200, 1, 170.00, 79.35, NULL, NULL, NULL, NULL, '2026-04-29 09:30:00', 0, '2026-04-29 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (481, 200, 1, 170.00, 79.20, NULL, NULL, NULL, NULL, '2026-04-30 09:30:00', 0, '2026-04-30 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (482, 200, 1, 170.00, 79.05, NULL, NULL, NULL, NULL, '2026-05-01 09:30:00', 0, '2026-05-01 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (483, 200, 1, 170.00, 78.91, NULL, NULL, NULL, NULL, '2026-05-02 09:30:00', 0, '2026-05-02 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (484, 200, 1, 170.00, 78.76, NULL, NULL, NULL, NULL, '2026-05-03 09:30:00', 0, '2026-05-03 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (485, 200, 1, 170.00, 78.61, NULL, NULL, NULL, NULL, '2026-05-04 09:30:00', 0, '2026-05-04 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (486, 200, 1, 170.00, 78.47, NULL, NULL, NULL, NULL, '2026-05-05 09:30:00', 0, '2026-05-05 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (487, 200, 1, 170.00, 78.32, NULL, NULL, NULL, NULL, '2026-05-06 09:30:00', 0, '2026-05-06 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (488, 200, 1, 170.00, 78.17, NULL, NULL, NULL, NULL, '2026-05-07 09:30:00', 0, '2026-05-07 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (489, 200, 1, 170.00, 78.03, NULL, NULL, NULL, NULL, '2026-05-08 09:30:00', 0, '2026-05-08 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (490, 200, 1, 170.00, 77.88, NULL, NULL, NULL, NULL, '2026-05-09 09:30:00', 0, '2026-05-09 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (491, 200, 1, 170.00, 77.73, NULL, NULL, NULL, NULL, '2026-05-10 09:30:00', 0, '2026-05-10 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (492, 200, 1, 170.00, 77.59, NULL, NULL, NULL, NULL, '2026-05-11 09:30:00', 0, '2026-05-11 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (493, 200, 1, 170.00, 77.44, NULL, NULL, NULL, NULL, '2026-05-12 09:30:00', 0, '2026-05-12 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (494, 200, 1, 170.00, 77.29, NULL, NULL, NULL, NULL, '2026-05-13 09:30:00', 0, '2026-05-13 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (495, 200, 1, 170.00, 77.15, NULL, NULL, NULL, NULL, '2026-05-14 09:30:00', 0, '2026-05-14 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (496, 200, 1, 170.00, 77.00, NULL, NULL, NULL, NULL, '2026-05-15 09:30:00', 0, '2026-05-15 09:31:00', '2026-05-15 16:26:27');
INSERT INTO `health_data` VALUES (548, 200, 1, 170.00, 88.00, NULL, NULL, NULL, NULL, '2026-03-01 09:30:00', 0, '2026-03-01 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (549, 200, 1, 170.00, 87.85, NULL, NULL, NULL, NULL, '2026-03-02 09:30:00', 0, '2026-03-02 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (550, 200, 1, 170.00, 87.71, NULL, NULL, NULL, NULL, '2026-03-03 09:30:00', 0, '2026-03-03 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (551, 200, 1, 170.00, 87.56, NULL, NULL, NULL, NULL, '2026-03-04 09:30:00', 0, '2026-03-04 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (552, 200, 1, 170.00, 87.41, NULL, NULL, NULL, NULL, '2026-03-05 09:30:00', 0, '2026-03-05 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (553, 200, 1, 170.00, 87.27, NULL, NULL, NULL, NULL, '2026-03-06 09:30:00', 0, '2026-03-06 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (554, 200, 1, 170.00, 87.12, NULL, NULL, NULL, NULL, '2026-03-07 09:30:00', 0, '2026-03-07 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (555, 200, 1, 170.00, 86.97, NULL, NULL, NULL, NULL, '2026-03-08 09:30:00', 0, '2026-03-08 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (556, 200, 1, 170.00, 86.83, NULL, NULL, NULL, NULL, '2026-03-09 09:30:00', 0, '2026-03-09 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (557, 200, 1, 170.00, 86.68, NULL, NULL, NULL, NULL, '2026-03-10 09:30:00', 0, '2026-03-10 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (558, 200, 1, 170.00, 86.53, NULL, NULL, NULL, NULL, '2026-03-11 09:30:00', 0, '2026-03-11 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (559, 200, 1, 170.00, 86.39, NULL, NULL, NULL, NULL, '2026-03-12 09:30:00', 0, '2026-03-12 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (560, 200, 1, 170.00, 86.24, NULL, NULL, NULL, NULL, '2026-03-13 09:30:00', 0, '2026-03-13 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (561, 200, 1, 170.00, 86.09, NULL, NULL, NULL, NULL, '2026-03-14 09:30:00', 0, '2026-03-14 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (562, 200, 1, 170.00, 85.95, NULL, NULL, NULL, NULL, '2026-03-15 09:30:00', 0, '2026-03-15 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (563, 200, 1, 170.00, 85.80, NULL, NULL, NULL, NULL, '2026-03-16 09:30:00', 0, '2026-03-16 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (564, 200, 1, 170.00, 85.65, NULL, NULL, NULL, NULL, '2026-03-17 09:30:00', 0, '2026-03-17 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (565, 200, 1, 170.00, 85.51, NULL, NULL, NULL, NULL, '2026-03-18 09:30:00', 0, '2026-03-18 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (566, 200, 1, 170.00, 85.36, NULL, NULL, NULL, NULL, '2026-03-19 09:30:00', 0, '2026-03-19 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (567, 200, 1, 170.00, 85.21, NULL, NULL, NULL, NULL, '2026-03-20 09:30:00', 0, '2026-03-20 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (568, 200, 1, 170.00, 85.07, NULL, NULL, NULL, NULL, '2026-03-21 09:30:00', 0, '2026-03-21 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (569, 200, 1, 170.00, 84.92, NULL, NULL, NULL, NULL, '2026-03-22 09:30:00', 0, '2026-03-22 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (570, 200, 1, 170.00, 84.77, NULL, NULL, NULL, NULL, '2026-03-23 09:30:00', 0, '2026-03-23 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (571, 200, 1, 170.00, 84.63, NULL, NULL, NULL, NULL, '2026-03-24 09:30:00', 0, '2026-03-24 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (572, 200, 1, 170.00, 84.48, NULL, NULL, NULL, NULL, '2026-03-25 09:30:00', 0, '2026-03-25 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (573, 200, 1, 170.00, 84.33, NULL, NULL, NULL, NULL, '2026-03-26 09:30:00', 0, '2026-03-26 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (574, 200, 1, 170.00, 84.19, NULL, NULL, NULL, NULL, '2026-03-27 09:30:00', 0, '2026-03-27 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (575, 200, 1, 170.00, 84.04, NULL, NULL, NULL, NULL, '2026-03-28 09:30:00', 0, '2026-03-28 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (576, 200, 1, 170.00, 83.89, NULL, NULL, NULL, NULL, '2026-03-29 09:30:00', 0, '2026-03-29 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (577, 200, 1, 170.00, 83.75, NULL, NULL, NULL, NULL, '2026-03-30 09:30:00', 0, '2026-03-30 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (578, 200, 1, 170.00, 83.60, NULL, NULL, NULL, NULL, '2026-03-31 09:30:00', 0, '2026-03-31 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (579, 200, 1, 170.00, 83.45, NULL, NULL, NULL, NULL, '2026-04-01 09:30:00', 0, '2026-04-01 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (580, 200, 1, 170.00, 83.31, NULL, NULL, NULL, NULL, '2026-04-02 09:30:00', 0, '2026-04-02 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (581, 200, 1, 170.00, 83.16, NULL, NULL, NULL, NULL, '2026-04-03 09:30:00', 0, '2026-04-03 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (582, 200, 1, 170.00, 83.01, NULL, NULL, NULL, NULL, '2026-04-04 09:30:00', 0, '2026-04-04 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (583, 200, 1, 170.00, 82.87, NULL, NULL, NULL, NULL, '2026-04-05 09:30:00', 0, '2026-04-05 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (584, 200, 1, 170.00, 82.72, NULL, NULL, NULL, NULL, '2026-04-06 09:30:00', 0, '2026-04-06 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (585, 200, 1, 170.00, 82.57, NULL, NULL, NULL, NULL, '2026-04-07 09:30:00', 0, '2026-04-07 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (586, 200, 1, 170.00, 82.43, NULL, NULL, NULL, NULL, '2026-04-08 09:30:00', 0, '2026-04-08 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (587, 200, 1, 170.00, 82.28, NULL, NULL, NULL, NULL, '2026-04-09 09:30:00', 0, '2026-04-09 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (588, 200, 1, 170.00, 82.13, NULL, NULL, NULL, NULL, '2026-04-10 09:30:00', 0, '2026-04-10 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (589, 200, 1, 170.00, 81.99, NULL, NULL, NULL, NULL, '2026-04-11 09:30:00', 0, '2026-04-11 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (590, 200, 1, 170.00, 81.84, NULL, NULL, NULL, NULL, '2026-04-12 09:30:00', 0, '2026-04-12 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (591, 200, 1, 170.00, 81.69, NULL, NULL, NULL, NULL, '2026-04-13 09:30:00', 0, '2026-04-13 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (592, 200, 1, 170.00, 81.55, NULL, NULL, NULL, NULL, '2026-04-14 09:30:00', 0, '2026-04-14 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (593, 200, 1, 170.00, 81.40, NULL, NULL, NULL, NULL, '2026-04-15 09:30:00', 0, '2026-04-15 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (594, 200, 1, 170.00, 81.25, NULL, NULL, NULL, NULL, '2026-04-16 09:30:00', 0, '2026-04-16 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (595, 200, 1, 170.00, 81.11, NULL, NULL, NULL, NULL, '2026-04-17 09:30:00', 0, '2026-04-17 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (596, 200, 1, 170.00, 80.96, NULL, NULL, NULL, NULL, '2026-04-18 09:30:00', 0, '2026-04-18 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (597, 200, 1, 170.00, 80.81, NULL, NULL, NULL, NULL, '2026-04-19 09:30:00', 0, '2026-04-19 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (598, 200, 1, 170.00, 80.67, NULL, NULL, NULL, NULL, '2026-04-20 09:30:00', 0, '2026-04-20 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (599, 200, 1, 170.00, 80.52, NULL, NULL, NULL, NULL, '2026-04-21 09:30:00', 0, '2026-04-21 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (600, 200, 1, 170.00, 80.37, NULL, NULL, NULL, NULL, '2026-04-22 09:30:00', 0, '2026-04-22 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (601, 200, 1, 170.00, 80.23, NULL, NULL, NULL, NULL, '2026-04-23 09:30:00', 0, '2026-04-23 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (602, 200, 1, 170.00, 80.08, NULL, NULL, NULL, NULL, '2026-04-24 09:30:00', 0, '2026-04-24 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (603, 200, 1, 170.00, 79.93, NULL, NULL, NULL, NULL, '2026-04-25 09:30:00', 0, '2026-04-25 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (604, 200, 1, 170.00, 79.79, NULL, NULL, NULL, NULL, '2026-04-26 09:30:00', 0, '2026-04-26 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (605, 200, 1, 170.00, 79.64, NULL, NULL, NULL, NULL, '2026-04-27 09:30:00', 0, '2026-04-27 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (606, 200, 1, 170.00, 79.49, NULL, NULL, NULL, NULL, '2026-04-28 09:30:00', 0, '2026-04-28 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (607, 200, 1, 170.00, 79.35, NULL, NULL, NULL, NULL, '2026-04-29 09:30:00', 0, '2026-04-29 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (608, 200, 1, 170.00, 79.20, NULL, NULL, NULL, NULL, '2026-04-30 09:30:00', 0, '2026-04-30 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (609, 200, 1, 170.00, 79.05, NULL, NULL, NULL, NULL, '2026-05-01 09:30:00', 0, '2026-05-01 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (610, 200, 1, 170.00, 78.91, NULL, NULL, NULL, NULL, '2026-05-02 09:30:00', 0, '2026-05-02 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (611, 200, 1, 170.00, 78.76, NULL, NULL, NULL, NULL, '2026-05-03 09:30:00', 0, '2026-05-03 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (612, 200, 1, 170.00, 78.61, NULL, NULL, NULL, NULL, '2026-05-04 09:30:00', 0, '2026-05-04 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (613, 200, 1, 170.00, 78.47, NULL, NULL, NULL, NULL, '2026-05-05 09:30:00', 0, '2026-05-05 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (614, 200, 1, 170.00, 78.32, NULL, NULL, NULL, NULL, '2026-05-06 09:30:00', 0, '2026-05-06 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (615, 200, 1, 170.00, 78.17, NULL, NULL, NULL, NULL, '2026-05-07 09:30:00', 0, '2026-05-07 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (616, 200, 1, 170.00, 78.03, NULL, NULL, NULL, NULL, '2026-05-08 09:30:00', 0, '2026-05-08 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (617, 200, 1, 170.00, 77.88, NULL, NULL, NULL, NULL, '2026-05-09 09:30:00', 0, '2026-05-09 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (618, 200, 1, 170.00, 77.73, NULL, NULL, NULL, NULL, '2026-05-10 09:30:00', 0, '2026-05-10 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (619, 200, 1, 170.00, 77.59, NULL, NULL, NULL, NULL, '2026-05-11 09:30:00', 0, '2026-05-11 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (620, 200, 1, 170.00, 77.44, NULL, NULL, NULL, NULL, '2026-05-12 09:30:00', 0, '2026-05-12 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (621, 200, 1, 170.00, 77.29, NULL, NULL, NULL, NULL, '2026-05-13 09:30:00', 0, '2026-05-13 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (622, 200, 1, 170.00, 77.15, NULL, NULL, NULL, NULL, '2026-05-14 09:30:00', 0, '2026-05-14 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (623, 200, 1, 170.00, 77.00, NULL, NULL, NULL, NULL, '2026-05-15 09:30:00', 0, '2026-05-15 09:31:00', '2026-05-15 16:27:23');
INSERT INTO `health_data` VALUES (1767, 6, 1, 170.00, 88.00, NULL, NULL, NULL, NULL, '2026-03-01 09:30:00', 0, '2026-03-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1768, 6, 1, 170.00, 87.85, NULL, NULL, NULL, NULL, '2026-03-02 09:30:00', 0, '2026-03-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1769, 6, 1, 170.00, 87.71, NULL, NULL, NULL, NULL, '2026-03-03 09:30:00', 0, '2026-03-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1770, 6, 1, 170.00, 87.56, NULL, NULL, NULL, NULL, '2026-03-04 09:30:00', 0, '2026-03-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1771, 6, 1, 170.00, 87.41, NULL, NULL, NULL, NULL, '2026-03-05 09:30:00', 0, '2026-03-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1772, 6, 1, 170.00, 87.27, NULL, NULL, NULL, NULL, '2026-03-06 09:30:00', 0, '2026-03-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1773, 6, 1, 170.00, 87.12, NULL, NULL, NULL, NULL, '2026-03-07 09:30:00', 0, '2026-03-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1774, 6, 1, 170.00, 86.97, NULL, NULL, NULL, NULL, '2026-03-08 09:30:00', 0, '2026-03-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1775, 6, 1, 170.00, 86.83, NULL, NULL, NULL, NULL, '2026-03-09 09:30:00', 0, '2026-03-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1776, 6, 1, 170.00, 86.68, NULL, NULL, NULL, NULL, '2026-03-10 09:30:00', 0, '2026-03-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1777, 6, 1, 170.00, 86.53, NULL, NULL, NULL, NULL, '2026-03-11 09:30:00', 0, '2026-03-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1778, 6, 1, 170.00, 86.39, NULL, NULL, NULL, NULL, '2026-03-12 09:30:00', 0, '2026-03-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1779, 6, 1, 170.00, 86.24, NULL, NULL, NULL, NULL, '2026-03-13 09:30:00', 0, '2026-03-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1780, 6, 1, 170.00, 86.09, NULL, NULL, NULL, NULL, '2026-03-14 09:30:00', 0, '2026-03-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1781, 6, 1, 170.00, 85.95, NULL, NULL, NULL, NULL, '2026-03-15 09:30:00', 0, '2026-03-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1782, 6, 1, 170.00, 85.80, NULL, NULL, NULL, NULL, '2026-03-16 09:30:00', 0, '2026-03-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1783, 6, 1, 170.00, 85.65, NULL, NULL, NULL, NULL, '2026-03-17 09:30:00', 0, '2026-03-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1784, 6, 1, 170.00, 85.51, NULL, NULL, NULL, NULL, '2026-03-18 09:30:00', 0, '2026-03-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1785, 6, 1, 170.00, 85.36, NULL, NULL, NULL, NULL, '2026-03-19 09:30:00', 0, '2026-03-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1786, 6, 1, 170.00, 85.21, NULL, NULL, NULL, NULL, '2026-03-20 09:30:00', 0, '2026-03-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1787, 6, 1, 170.00, 85.07, NULL, NULL, NULL, NULL, '2026-03-21 09:30:00', 0, '2026-03-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1788, 6, 1, 170.00, 84.92, NULL, NULL, NULL, NULL, '2026-03-22 09:30:00', 0, '2026-03-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1789, 6, 1, 170.00, 84.77, NULL, NULL, NULL, NULL, '2026-03-23 09:30:00', 0, '2026-03-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1790, 6, 1, 170.00, 84.63, NULL, NULL, NULL, NULL, '2026-03-24 09:30:00', 0, '2026-03-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1791, 6, 1, 170.00, 84.48, NULL, NULL, NULL, NULL, '2026-03-25 09:30:00', 0, '2026-03-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1792, 6, 1, 170.00, 84.33, NULL, NULL, NULL, NULL, '2026-03-26 09:30:00', 0, '2026-03-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1793, 6, 1, 170.00, 84.19, NULL, NULL, NULL, NULL, '2026-03-27 09:30:00', 0, '2026-03-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1794, 6, 1, 170.00, 84.04, NULL, NULL, NULL, NULL, '2026-03-28 09:30:00', 0, '2026-03-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1795, 6, 1, 170.00, 83.89, NULL, NULL, NULL, NULL, '2026-03-29 09:30:00', 0, '2026-03-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1796, 6, 1, 170.00, 83.75, NULL, NULL, NULL, NULL, '2026-03-30 09:30:00', 0, '2026-03-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1797, 6, 1, 170.00, 83.60, NULL, NULL, NULL, NULL, '2026-03-31 09:30:00', 0, '2026-03-31 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1798, 6, 1, 170.00, 83.45, NULL, NULL, NULL, NULL, '2026-04-01 09:30:00', 0, '2026-04-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1799, 6, 1, 170.00, 83.31, NULL, NULL, NULL, NULL, '2026-04-02 09:30:00', 0, '2026-04-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1800, 6, 1, 170.00, 83.16, NULL, NULL, NULL, NULL, '2026-04-03 09:30:00', 0, '2026-04-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1801, 6, 1, 170.00, 83.01, NULL, NULL, NULL, NULL, '2026-04-04 09:30:00', 0, '2026-04-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1802, 6, 1, 170.00, 82.87, NULL, NULL, NULL, NULL, '2026-04-05 09:30:00', 0, '2026-04-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1803, 6, 1, 170.00, 82.72, NULL, NULL, NULL, NULL, '2026-04-06 09:30:00', 0, '2026-04-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1804, 6, 1, 170.00, 82.57, NULL, NULL, NULL, NULL, '2026-04-07 09:30:00', 0, '2026-04-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1805, 6, 1, 170.00, 82.43, NULL, NULL, NULL, NULL, '2026-04-08 09:30:00', 0, '2026-04-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1806, 6, 1, 170.00, 82.28, NULL, NULL, NULL, NULL, '2026-04-09 09:30:00', 0, '2026-04-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1807, 6, 1, 170.00, 82.13, NULL, NULL, NULL, NULL, '2026-04-10 09:30:00', 0, '2026-04-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1808, 6, 1, 170.00, 81.99, NULL, NULL, NULL, NULL, '2026-04-11 09:30:00', 0, '2026-04-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1809, 6, 1, 170.00, 81.84, NULL, NULL, NULL, NULL, '2026-04-12 09:30:00', 0, '2026-04-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1810, 6, 1, 170.00, 81.69, NULL, NULL, NULL, NULL, '2026-04-13 09:30:00', 0, '2026-04-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1811, 6, 1, 170.00, 81.55, NULL, NULL, NULL, NULL, '2026-04-14 09:30:00', 0, '2026-04-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1812, 6, 1, 170.00, 81.40, NULL, NULL, NULL, NULL, '2026-04-15 09:30:00', 0, '2026-04-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1813, 6, 1, 170.00, 81.25, NULL, NULL, NULL, NULL, '2026-04-16 09:30:00', 0, '2026-04-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1814, 6, 1, 170.00, 81.11, NULL, NULL, NULL, NULL, '2026-04-17 09:30:00', 0, '2026-04-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1815, 6, 1, 170.00, 80.96, NULL, NULL, NULL, NULL, '2026-04-18 09:30:00', 0, '2026-04-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1816, 6, 1, 170.00, 80.81, NULL, NULL, NULL, NULL, '2026-04-19 09:30:00', 0, '2026-04-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1817, 6, 1, 170.00, 80.67, NULL, NULL, NULL, NULL, '2026-04-20 09:30:00', 0, '2026-04-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1818, 6, 1, 170.00, 80.52, NULL, NULL, NULL, NULL, '2026-04-21 09:30:00', 0, '2026-04-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1819, 6, 1, 170.00, 80.37, NULL, NULL, NULL, NULL, '2026-04-22 09:30:00', 0, '2026-04-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1820, 6, 1, 170.00, 80.23, NULL, NULL, NULL, NULL, '2026-04-23 09:30:00', 0, '2026-04-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1821, 6, 1, 170.00, 80.08, NULL, NULL, NULL, NULL, '2026-04-24 09:30:00', 0, '2026-04-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1822, 6, 1, 170.00, 79.93, NULL, NULL, NULL, NULL, '2026-04-25 09:30:00', 0, '2026-04-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1823, 6, 1, 170.00, 79.79, NULL, NULL, NULL, NULL, '2026-04-26 09:30:00', 0, '2026-04-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1824, 6, 1, 170.00, 79.64, NULL, NULL, NULL, NULL, '2026-04-27 09:30:00', 0, '2026-04-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1825, 6, 1, 170.00, 79.49, NULL, NULL, NULL, NULL, '2026-04-28 09:30:00', 0, '2026-04-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1826, 6, 1, 170.00, 79.35, NULL, NULL, NULL, NULL, '2026-04-29 09:30:00', 0, '2026-04-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1827, 6, 1, 170.00, 79.20, NULL, NULL, NULL, NULL, '2026-04-30 09:30:00', 0, '2026-04-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1828, 6, 1, 170.00, 79.05, NULL, NULL, NULL, NULL, '2026-05-01 09:30:00', 0, '2026-05-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1829, 6, 1, 170.00, 78.91, NULL, NULL, NULL, NULL, '2026-05-02 09:30:00', 0, '2026-05-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1830, 6, 1, 170.00, 78.76, NULL, NULL, NULL, NULL, '2026-05-03 09:30:00', 0, '2026-05-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1831, 6, 1, 170.00, 78.61, NULL, NULL, NULL, NULL, '2026-05-04 09:30:00', 0, '2026-05-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1832, 6, 1, 170.00, 78.47, NULL, NULL, NULL, NULL, '2026-05-05 09:30:00', 0, '2026-05-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1833, 6, 1, 170.00, 78.32, NULL, NULL, NULL, NULL, '2026-05-06 09:30:00', 0, '2026-05-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1834, 6, 1, 170.00, 78.17, NULL, NULL, NULL, NULL, '2026-05-07 09:30:00', 0, '2026-05-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1835, 6, 1, 170.00, 78.03, NULL, NULL, NULL, NULL, '2026-05-08 09:30:00', 0, '2026-05-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1836, 6, 1, 170.00, 77.88, NULL, NULL, NULL, NULL, '2026-05-09 09:30:00', 0, '2026-05-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1837, 6, 1, 170.00, 77.73, NULL, NULL, NULL, NULL, '2026-05-10 09:30:00', 0, '2026-05-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1838, 6, 1, 170.00, 77.59, NULL, NULL, NULL, NULL, '2026-05-11 09:30:00', 0, '2026-05-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1839, 6, 1, 170.00, 77.44, NULL, NULL, NULL, NULL, '2026-05-12 09:30:00', 0, '2026-05-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1840, 6, 1, 170.00, 77.29, NULL, NULL, NULL, NULL, '2026-05-13 09:30:00', 0, '2026-05-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1841, 6, 1, 170.00, 77.15, NULL, NULL, NULL, NULL, '2026-05-14 09:30:00', 0, '2026-05-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1842, 6, 1, 170.00, 69.00, NULL, NULL, NULL, NULL, '2026-05-19 18:36:11', 0, '2026-05-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1843, 6, 2, NULL, NULL, 128, 82, NULL, NULL, '2026-03-01 09:30:00', 0, '2026-03-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1844, 6, 2, NULL, NULL, 128, 82, NULL, NULL, '2026-03-02 09:30:00', 0, '2026-03-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1845, 6, 2, NULL, NULL, 128, 82, NULL, NULL, '2026-03-03 09:30:00', 0, '2026-03-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1846, 6, 2, NULL, NULL, 128, 82, NULL, NULL, '2026-03-04 09:30:00', 0, '2026-03-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1847, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-05 09:30:00', 0, '2026-03-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1848, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-06 09:30:00', 0, '2026-03-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1849, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-07 09:30:00', 0, '2026-03-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1850, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-08 09:30:00', 0, '2026-03-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1851, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-09 09:30:00', 0, '2026-03-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1852, 6, 2, NULL, NULL, 127, 82, NULL, NULL, '2026-03-10 09:30:00', 0, '2026-03-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1853, 6, 2, NULL, NULL, 127, 81, NULL, NULL, '2026-03-11 09:30:00', 0, '2026-03-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1854, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-12 09:30:00', 0, '2026-03-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1855, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-13 09:30:00', 0, '2026-03-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1856, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-14 09:30:00', 0, '2026-03-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1857, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-15 09:30:00', 0, '2026-03-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1858, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-16 09:30:00', 0, '2026-03-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1859, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-17 09:30:00', 0, '2026-03-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1860, 6, 2, NULL, NULL, 126, 81, NULL, NULL, '2026-03-18 09:30:00', 0, '2026-03-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1861, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-19 09:30:00', 0, '2026-03-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1862, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-20 09:30:00', 0, '2026-03-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1863, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-21 09:30:00', 0, '2026-03-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1864, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-22 09:30:00', 0, '2026-03-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1865, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-23 09:30:00', 0, '2026-03-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1866, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-24 09:30:00', 0, '2026-03-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1867, 6, 2, NULL, NULL, 125, 81, NULL, NULL, '2026-03-25 09:30:00', 0, '2026-03-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1868, 6, 2, NULL, NULL, 124, 81, NULL, NULL, '2026-03-26 09:30:00', 0, '2026-03-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1869, 6, 2, NULL, NULL, 124, 81, NULL, NULL, '2026-03-27 09:30:00', 0, '2026-03-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1870, 6, 2, NULL, NULL, 124, 81, NULL, NULL, '2026-03-28 09:30:00', 0, '2026-03-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1871, 6, 2, NULL, NULL, 124, 81, NULL, NULL, '2026-03-29 09:30:00', 0, '2026-03-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1872, 6, 2, NULL, NULL, 124, 81, NULL, NULL, '2026-03-30 09:30:00', 0, '2026-03-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1873, 6, 2, NULL, NULL, 124, 80, NULL, NULL, '2026-03-31 09:30:00', 0, '2026-03-31 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1874, 6, 2, NULL, NULL, 124, 80, NULL, NULL, '2026-04-01 09:30:00', 0, '2026-04-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1875, 6, 2, NULL, NULL, 124, 80, NULL, NULL, '2026-04-02 09:30:00', 0, '2026-04-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1876, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-03 09:30:00', 0, '2026-04-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1877, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-04 09:30:00', 0, '2026-04-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1878, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-05 09:30:00', 0, '2026-04-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1879, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-06 09:30:00', 0, '2026-04-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1880, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-07 09:30:00', 0, '2026-04-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1881, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-08 09:30:00', 0, '2026-04-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1882, 6, 2, NULL, NULL, 123, 80, NULL, NULL, '2026-04-09 09:30:00', 0, '2026-04-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1883, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-10 09:30:00', 0, '2026-04-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1884, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-11 09:30:00', 0, '2026-04-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1885, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-12 09:30:00', 0, '2026-04-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1886, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-13 09:30:00', 0, '2026-04-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1887, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-14 09:30:00', 0, '2026-04-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1888, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-15 09:30:00', 0, '2026-04-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1889, 6, 2, NULL, NULL, 122, 80, NULL, NULL, '2026-04-16 09:30:00', 0, '2026-04-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1890, 6, 2, NULL, NULL, 121, 80, NULL, NULL, '2026-04-17 09:30:00', 0, '2026-04-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1891, 6, 2, NULL, NULL, 121, 80, NULL, NULL, '2026-04-18 09:30:00', 0, '2026-04-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1892, 6, 2, NULL, NULL, 121, 80, NULL, NULL, '2026-04-19 09:30:00', 0, '2026-04-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1893, 6, 2, NULL, NULL, 121, 79, NULL, NULL, '2026-04-20 09:30:00', 0, '2026-04-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1894, 6, 2, NULL, NULL, 121, 79, NULL, NULL, '2026-04-21 09:30:00', 0, '2026-04-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1895, 6, 2, NULL, NULL, 121, 79, NULL, NULL, '2026-04-22 09:30:00', 0, '2026-04-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1896, 6, 2, NULL, NULL, 121, 79, NULL, NULL, '2026-04-23 09:30:00', 0, '2026-04-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1897, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-24 09:30:00', 0, '2026-04-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1898, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-25 09:30:00', 0, '2026-04-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1899, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-26 09:30:00', 0, '2026-04-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1900, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-27 09:30:00', 0, '2026-04-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1901, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-28 09:30:00', 0, '2026-04-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1902, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-29 09:30:00', 0, '2026-04-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1903, 6, 2, NULL, NULL, 120, 79, NULL, NULL, '2026-04-30 09:30:00', 0, '2026-04-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1904, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-01 09:30:00', 0, '2026-05-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1905, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-02 09:30:00', 0, '2026-05-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1906, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-03 09:30:00', 0, '2026-05-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1907, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-04 09:30:00', 0, '2026-05-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1908, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-05 09:30:00', 0, '2026-05-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1909, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-06 09:30:00', 0, '2026-05-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1910, 6, 2, NULL, NULL, 119, 79, NULL, NULL, '2026-05-07 09:30:00', 0, '2026-05-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1911, 6, 2, NULL, NULL, 118, 79, NULL, NULL, '2026-05-08 09:30:00', 0, '2026-05-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1912, 6, 2, NULL, NULL, 118, 79, NULL, NULL, '2026-05-09 09:30:00', 0, '2026-05-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1913, 6, 2, NULL, NULL, 118, 78, NULL, NULL, '2026-05-10 09:30:00', 0, '2026-05-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1914, 6, 2, NULL, NULL, 118, 78, NULL, NULL, '2026-05-11 09:30:00', 0, '2026-05-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1915, 6, 2, NULL, NULL, 118, 78, NULL, NULL, '2026-05-12 09:30:00', 0, '2026-05-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1916, 6, 2, NULL, NULL, 118, 78, NULL, NULL, '2026-05-13 09:30:00', 0, '2026-05-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1917, 6, 2, NULL, NULL, 118, 78, NULL, NULL, '2026-05-14 09:30:00', 0, '2026-05-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1918, 6, 2, NULL, NULL, 117, 78, NULL, NULL, '2026-05-19 18:36:11', 0, '2026-05-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1919, 6, 3, NULL, NULL, NULL, NULL, 5.82, NULL, '2026-03-01 09:30:00', 0, '2026-03-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1920, 6, 3, NULL, NULL, NULL, NULL, 5.82, NULL, '2026-03-02 09:30:00', 0, '2026-03-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1921, 6, 3, NULL, NULL, NULL, NULL, 5.82, NULL, '2026-03-03 09:30:00', 0, '2026-03-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1922, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-04 09:30:00', 0, '2026-03-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1923, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-05 09:30:00', 0, '2026-03-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1924, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-06 09:30:00', 0, '2026-03-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1925, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-07 09:30:00', 0, '2026-03-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1926, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-08 09:30:00', 0, '2026-03-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1927, 6, 3, NULL, NULL, NULL, NULL, 5.81, NULL, '2026-03-09 09:30:00', 0, '2026-03-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1928, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-10 09:30:00', 0, '2026-03-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1929, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-11 09:30:00', 0, '2026-03-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1930, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-12 09:30:00', 0, '2026-03-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1931, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-13 09:30:00', 0, '2026-03-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1932, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-14 09:30:00', 0, '2026-03-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1933, 6, 3, NULL, NULL, NULL, NULL, 5.80, NULL, '2026-03-15 09:30:00', 0, '2026-03-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1934, 6, 3, NULL, NULL, NULL, NULL, 5.79, NULL, '2026-03-16 09:30:00', 0, '2026-03-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1935, 6, 3, NULL, NULL, NULL, NULL, 5.79, NULL, '2026-03-17 09:30:00', 0, '2026-03-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1936, 6, 3, NULL, NULL, NULL, NULL, 5.79, NULL, '2026-03-18 09:30:00', 0, '2026-03-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1937, 6, 3, NULL, NULL, NULL, NULL, 5.79, NULL, '2026-03-19 09:30:00', 0, '2026-03-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1938, 6, 3, NULL, NULL, NULL, NULL, 5.79, NULL, '2026-03-20 09:30:00', 0, '2026-03-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1939, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-21 09:30:00', 0, '2026-03-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1940, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-22 09:30:00', 0, '2026-03-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1941, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-23 09:30:00', 0, '2026-03-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1942, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-24 09:30:00', 0, '2026-03-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1943, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-25 09:30:00', 0, '2026-03-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1944, 6, 3, NULL, NULL, NULL, NULL, 5.78, NULL, '2026-03-26 09:30:00', 0, '2026-03-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1945, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-03-27 09:30:00', 0, '2026-03-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1946, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-03-28 09:30:00', 0, '2026-03-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1947, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-03-29 09:30:00', 0, '2026-03-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1948, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-03-30 09:30:00', 0, '2026-03-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1949, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-03-31 09:30:00', 0, '2026-03-31 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1950, 6, 3, NULL, NULL, NULL, NULL, 5.77, NULL, '2026-04-01 09:30:00', 0, '2026-04-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1951, 6, 3, NULL, NULL, NULL, NULL, 5.76, NULL, '2026-04-02 09:30:00', 0, '2026-04-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1952, 6, 3, NULL, NULL, NULL, NULL, 5.76, NULL, '2026-04-03 09:30:00', 0, '2026-04-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1953, 6, 3, NULL, NULL, NULL, NULL, 5.76, NULL, '2026-04-04 09:30:00', 0, '2026-04-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1954, 6, 3, NULL, NULL, NULL, NULL, 5.76, NULL, '2026-04-05 09:30:00', 0, '2026-04-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1955, 6, 3, NULL, NULL, NULL, NULL, 5.76, NULL, '2026-04-06 09:30:00', 0, '2026-04-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1956, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-07 09:30:00', 0, '2026-04-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1957, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-08 09:30:00', 0, '2026-04-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1958, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-09 09:30:00', 0, '2026-04-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1959, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-10 09:30:00', 0, '2026-04-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1960, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-11 09:30:00', 0, '2026-04-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1961, 6, 3, NULL, NULL, NULL, NULL, 5.75, NULL, '2026-04-12 09:30:00', 0, '2026-04-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1962, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-13 09:30:00', 0, '2026-04-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1963, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-14 09:30:00', 0, '2026-04-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1964, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-15 09:30:00', 0, '2026-04-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1965, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-16 09:30:00', 0, '2026-04-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1966, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-17 09:30:00', 0, '2026-04-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1967, 6, 3, NULL, NULL, NULL, NULL, 5.74, NULL, '2026-04-18 09:30:00', 0, '2026-04-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1968, 6, 3, NULL, NULL, NULL, NULL, 5.73, NULL, '2026-04-19 09:30:00', 0, '2026-04-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1969, 6, 3, NULL, NULL, NULL, NULL, 5.73, NULL, '2026-04-20 09:30:00', 0, '2026-04-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1970, 6, 3, NULL, NULL, NULL, NULL, 5.73, NULL, '2026-04-21 09:30:00', 0, '2026-04-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1971, 6, 3, NULL, NULL, NULL, NULL, 5.73, NULL, '2026-04-22 09:30:00', 0, '2026-04-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1972, 6, 3, NULL, NULL, NULL, NULL, 5.73, NULL, '2026-04-23 09:30:00', 0, '2026-04-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1973, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-24 09:30:00', 0, '2026-04-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1974, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-25 09:30:00', 0, '2026-04-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1975, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-26 09:30:00', 0, '2026-04-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1976, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-27 09:30:00', 0, '2026-04-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1977, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-28 09:30:00', 0, '2026-04-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1978, 6, 3, NULL, NULL, NULL, NULL, 5.72, NULL, '2026-04-29 09:30:00', 0, '2026-04-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1979, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-04-30 09:30:00', 0, '2026-04-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1980, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-05-01 09:30:00', 0, '2026-05-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1981, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-05-02 09:30:00', 0, '2026-05-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1982, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-05-03 09:30:00', 0, '2026-05-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1983, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-05-04 09:30:00', 0, '2026-05-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1984, 6, 3, NULL, NULL, NULL, NULL, 5.71, NULL, '2026-05-05 09:30:00', 0, '2026-05-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1985, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-06 09:30:00', 0, '2026-05-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1986, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-07 09:30:00', 0, '2026-05-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1987, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-08 09:30:00', 0, '2026-05-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1988, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-09 09:30:00', 0, '2026-05-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1989, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-10 09:30:00', 0, '2026-05-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1990, 6, 3, NULL, NULL, NULL, NULL, 5.70, NULL, '2026-05-11 09:30:00', 0, '2026-05-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1991, 6, 3, NULL, NULL, NULL, NULL, 5.69, NULL, '2026-05-12 09:30:00', 0, '2026-05-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1992, 6, 3, NULL, NULL, NULL, NULL, 5.69, NULL, '2026-05-13 09:30:00', 0, '2026-05-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1993, 6, 3, NULL, NULL, NULL, NULL, 5.69, NULL, '2026-05-14 09:30:00', 0, '2026-05-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1994, 6, 3, NULL, NULL, NULL, NULL, 5.69, NULL, '2026-05-19 18:36:11', 0, '2026-05-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1995, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.28, '2026-03-01 09:30:00', 0, '2026-03-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1996, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.28, '2026-03-02 09:30:00', 0, '2026-03-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1997, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.28, '2026-03-03 09:30:00', 0, '2026-03-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1998, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.28, '2026-03-04 09:30:00', 0, '2026-03-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (1999, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-05 09:30:00', 0, '2026-03-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2000, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-06 09:30:00', 0, '2026-03-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2001, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-07 09:30:00', 0, '2026-03-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2002, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-08 09:30:00', 0, '2026-03-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2003, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-09 09:30:00', 0, '2026-03-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2004, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-10 09:30:00', 0, '2026-03-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2005, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-11 09:30:00', 0, '2026-03-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2006, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.27, '2026-03-12 09:30:00', 0, '2026-03-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2007, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-13 09:30:00', 0, '2026-03-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2008, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-14 09:30:00', 0, '2026-03-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2009, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-15 09:30:00', 0, '2026-03-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2010, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-16 09:30:00', 0, '2026-03-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2011, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-17 09:30:00', 0, '2026-03-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2012, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-18 09:30:00', 0, '2026-03-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2013, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.26, '2026-03-19 09:30:00', 0, '2026-03-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2014, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-20 09:30:00', 0, '2026-03-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2015, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-21 09:30:00', 0, '2026-03-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2016, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-22 09:30:00', 0, '2026-03-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2017, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-23 09:30:00', 0, '2026-03-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2018, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-24 09:30:00', 0, '2026-03-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2019, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-25 09:30:00', 0, '2026-03-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2020, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-26 09:30:00', 0, '2026-03-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2021, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.25, '2026-03-27 09:30:00', 0, '2026-03-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2022, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-03-28 09:30:00', 0, '2026-03-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2023, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-03-29 09:30:00', 0, '2026-03-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2024, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-03-30 09:30:00', 0, '2026-03-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2025, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-03-31 09:30:00', 0, '2026-03-31 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2026, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-04-01 09:30:00', 0, '2026-04-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2027, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-04-02 09:30:00', 0, '2026-04-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2028, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-04-03 09:30:00', 0, '2026-04-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2029, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.24, '2026-04-04 09:30:00', 0, '2026-04-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2030, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-05 09:30:00', 0, '2026-04-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2031, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-06 09:30:00', 0, '2026-04-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2032, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-07 09:30:00', 0, '2026-04-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2033, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-08 09:30:00', 0, '2026-04-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2034, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-09 09:30:00', 0, '2026-04-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2035, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-10 09:30:00', 0, '2026-04-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2036, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.23, '2026-04-11 09:30:00', 0, '2026-04-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2037, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-12 09:30:00', 0, '2026-04-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2038, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-13 09:30:00', 0, '2026-04-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2039, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-14 09:30:00', 0, '2026-04-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2040, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-15 09:30:00', 0, '2026-04-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2041, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-16 09:30:00', 0, '2026-04-16 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2042, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-17 09:30:00', 0, '2026-04-17 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2043, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-18 09:30:00', 0, '2026-04-18 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2044, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.22, '2026-04-19 09:30:00', 0, '2026-04-19 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2045, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-20 09:30:00', 0, '2026-04-20 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2046, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-21 09:30:00', 0, '2026-04-21 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2047, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-22 09:30:00', 0, '2026-04-22 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2048, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-23 09:30:00', 0, '2026-04-23 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2049, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-24 09:30:00', 0, '2026-04-24 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2050, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-25 09:30:00', 0, '2026-04-25 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2051, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.21, '2026-04-26 09:30:00', 0, '2026-04-26 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2052, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-04-27 09:30:00', 0, '2026-04-27 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2053, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-04-28 09:30:00', 0, '2026-04-28 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2054, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-04-29 09:30:00', 0, '2026-04-29 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2055, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-04-30 09:30:00', 0, '2026-04-30 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2056, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-05-01 09:30:00', 0, '2026-05-01 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2057, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-05-02 09:30:00', 0, '2026-05-02 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2058, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-05-03 09:30:00', 0, '2026-05-03 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2059, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.20, '2026-05-04 09:30:00', 0, '2026-05-04 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2060, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-05 09:30:00', 0, '2026-05-05 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2061, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-06 09:30:00', 0, '2026-05-06 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2062, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-07 09:30:00', 0, '2026-05-07 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2063, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-08 09:30:00', 0, '2026-05-08 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2064, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-09 09:30:00', 0, '2026-05-09 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2065, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-10 09:30:00', 0, '2026-05-10 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2066, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.19, '2026-05-11 09:30:00', 0, '2026-05-11 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2067, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.18, '2026-05-12 09:30:00', 0, '2026-05-12 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2068, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.18, '2026-05-13 09:30:00', 0, '2026-05-13 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2069, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.18, '2026-05-14 09:30:00', 0, '2026-05-14 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2070, 6, 4, NULL, NULL, NULL, NULL, NULL, 5.18, '2026-05-19 18:36:11', 0, '2026-05-15 09:30:00', '2026-05-15 18:11:03');
INSERT INTO `health_data` VALUES (2071, 106, 1, 168.00, 70.00, NULL, NULL, NULL, NULL, '2026-05-19 02:36:00', 1, '2026-05-19 10:36:02', '2026-05-19 10:36:02');
INSERT INTO `health_data` VALUES (2072, 106, 2, NULL, NULL, 130, 89, NULL, NULL, '2026-05-19 02:36:00', 0, '2026-05-19 10:36:02', '2026-05-19 10:36:02');
INSERT INTO `health_data` VALUES (2073, 106, 3, NULL, NULL, NULL, NULL, 4.00, NULL, '2026-05-19 02:36:00', 0, '2026-05-19 10:36:02', '2026-05-19 10:36:02');
INSERT INTO `health_data` VALUES (2074, 106, 4, NULL, NULL, NULL, NULL, NULL, 6.00, '2026-05-19 02:36:00', 1, '2026-05-19 10:36:02', '2026-05-19 10:36:02');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `admin_id` int NOT NULL COMMENT '管理员ID',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型',
  `target_table` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '目标表',
  `target_id` int NOT NULL COMMENT '目标ID',
  `old_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '旧值',
  `new_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '新值',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_admin_id`(`admin_id` ASC) USING BTREE,
  CONSTRAINT `fk_operation_log_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 2, 'DELETE_USER', 'user', 106, NULL, NULL, NULL, '2026-05-15 15:29:48', '2026-05-15 15:29:48');
INSERT INTO `operation_log` VALUES (2, 2, 'UPDATE_USER', 'user', 6, NULL, 'rql', NULL, '2026-05-15 16:35:31', '2026-05-15 16:35:30');
INSERT INTO `operation_log` VALUES (3, 2, 'UPDATE_USER', 'user', 6, NULL, 'rql', NULL, '2026-05-15 19:04:46', '2026-05-15 19:04:45');
INSERT INTO `operation_log` VALUES (4, 1, 'UPDATE_USER', 'user', 6, NULL, 'rql', NULL, '2026-05-19 18:34:33', '2026-05-19 18:34:33');
INSERT INTO `operation_log` VALUES (5, 1, 'UPDATE_USER', 'user', 6, NULL, 'rql', NULL, '2026-05-19 18:36:11', '2026-05-19 18:36:11');

-- ----------------------------
-- Table structure for recipe
-- ----------------------------
DROP TABLE IF EXISTS `recipe`;
CREATE TABLE `recipe`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '食谱ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '食谱名称',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '封面图URL',
  `ingredients` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '食材清单',
  `steps` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '制作步骤',
  `tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `suitable_constitution` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用体质',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览量',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-下架,1-上架',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '健康食谱表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recipe
-- ----------------------------
INSERT INTO `recipe` VALUES (1, '清蒸三文鱼藜麦碗', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800', '三文鱼200g,藜麦80g,西兰花100g', '藜麦煮熟；三文鱼蒸8分钟；混合摆盘', '高蛋白,减脂', '平和质,痰湿质', 1280, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (2, '番茄鸡胸意面', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800', '鸡胸肉150g,全麦意面100g,番茄2个', '鸡胸煎熟切块；番茄熬酱；拌入意面', '增肌,低脂', '平和质,气虚质', 1760, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (3, '山药小米粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '山药100g,小米80g,枸杞10g', '山药切块；小米煮粥；加入枸杞焖5分钟', '养胃,早餐', '气虚质,阳虚质', 2140, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (4, '冬瓜虾仁汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '冬瓜300g,虾仁120g,姜片', '冬瓜煮软；下虾仁煮2分钟；少盐调味', '清淡,晚餐', '湿热质,痰湿质', 1650, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (5, '菠菜豆腐蛋花汤', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '菠菜150g,嫩豆腐200g,鸡蛋1个', '豆腐煮开；加入菠菜；淋蛋液成花', '补铁,低卡', '阴虚质,血瘀质', 1390, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (6, '黑芝麻核桃糊', 'https://images.unsplash.com/photo-1478144592103-25e218a04891?w=800', '黑芝麻30g,核桃20g,燕麦20g', '食材炒香打粉；加热水搅匀成糊', '养发,能量', '血瘀质,气虚质', 980, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (7, '百合莲子银耳羹', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '干银耳15g,鲜百合50g,莲子30g,冰糖适量', '银耳泡发撕小朵；莲子去芯煮软；下银耳百合小火炖40分钟；调味', '润燥,甜品', '阴虚质,平和质', 640, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (8, '陈皮茯苓瘦肉汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '瘦肉200g,陈皮5g,茯苓15g,生姜2片', '瘦肉焯水；所有材料小火煲1小时；少盐', '健脾祛湿', '痰湿质,气虚质', 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (9, '枸杞叶猪肝汤', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '猪肝150g,枸杞叶100g,枸杞10g', '猪肝切片浸泡去血水；滚汤下猪肝枸杞叶煮熟', '补血,明目', '血瘀质,特禀质', 580, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (10, '绿豆薏米糖水', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800', '绿豆80g,薏米60g,冰糖适量', '绿豆薏米浸泡2小时；煮至开花；加冰糖溶化', '清热,利湿', '湿热质,平和质', 910, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (11, '黄芪党参炖鸡汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '土鸡半只,黄芪15g,党参10g,红枣5颗,姜片', '鸡块焯水；与药材同炖1.5小时；少盐', '补气,汤品', '气虚质,阳虚质', 1520, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (12, '凉拌木耳黄瓜', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '木耳50g,黄瓜1根,蒜末,香醋,香油', '木耳泡发焯水；黄瓜拍段；调料拌匀', '清爽,凉菜', '湿热质,痰湿质', 680, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (13, '红枣桂圆小米粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '小米100g,红枣6颗,桂圆肉15g', '小米煮粥；后下红枣桂圆煮10分钟', '补血安神,早餐', '血瘀质,气虚质', 890, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (14, '清蒸鲈鱼', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800', '鲈鱼1条,姜丝葱丝,蒸鱼豉油', '鱼身划刀铺姜；大火蒸8分钟；淋热油豉油', '高蛋白,清淡', '平和质,阴虚质', 1340, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (15, '海带豆腐汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '嫩豆腐200g,干海带30g,虾皮少许', '海带泡发切段；与豆腐煮汤15分钟', '碘钙,低脂', '痰湿质,特禀质', 560, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (16, '南瓜小米粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '南瓜200g,小米80g', '南瓜切丁与小米同煮至绵软', '养胃,粗粮', '气虚质,平和质', 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (17, '芹菜百合炒腰果', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '西芹200g,鲜百合80g,腰果50g', '腰果炒香盛出；芹菜百合快炒；回锅腰果', '润燥,素菜', '阴虚质,气郁质', 410, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (18, '萝卜牛腩煲', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '牛腩400g,白萝卜300g,八角桂皮少许', '牛腩炖软；下萝卜块炖30分钟', '温补,冬季', '阳虚质,气虚质', 1680, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (19, '凉拌三丝', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '胡萝卜,黄瓜,粉丝各适量,蒜泥醋', '粉丝泡软；三丝焯水；凉拌', '开胃,低卡', '湿热质,平和质', 390, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (20, '莲子芡实猪肚汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '猪肚半副,莲子30g,芡实20g,姜片', '猪肚洗净焯水；与莲子芡实小火煲2小时', '健脾固肾', '痰湿质,气虚质', 620, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (21, '紫薯燕麦粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '紫薯150g,燕麦50g,牛奶200ml', '紫薯蒸熟压泥；与燕麦牛奶煮成粥', '膳食纤维,早餐', '血瘀质,平和质', 510, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (22, '白灼菜心', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '菜心300g,蚝油,蒜末', '沸水加少许油盐焯菜心；淋蚝油蒜油', '清淡,粤菜', '湿热质,阴虚质', 480, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (23, '当归生姜羊肉汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '羊肉500g,当归10g,生姜30g', '羊肉焯水；与当归生姜小火炖1.5小时', '驱寒温补', '阳虚质,血瘀质', 2100, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (24, '香菇青菜面', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800', '鲜香菇100g,青菜150g,面条200g', '香菇炒香加水煮面；起锅前下青菜', '家常,素食', '平和质,气虚质', 340, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (25, '雪梨川贝盅', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800', '雪梨1个,川贝粉3g,冰糖少许', '雪梨挖核填川贝冰糖；蒸40分钟', '润肺,甜品', '阴虚质,特禀质', 770, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (26, '蒜蓉西兰花', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '西兰花300g,大蒜3瓣', '西兰花焯水；蒜蓉爆香快炒', '低卡,蔬菜', '痰湿质,平和质', 620, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (27, '黑豆核桃豆浆', 'https://images.unsplash.com/photo-1478144592103-25e218a04891?w=800', '黑豆40g,核桃20g,水800ml', '黑豆浸泡后与核桃打浆煮熟', '补肾,早餐饮品', '阴虚质,血瘀质', 450, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (28, '薏米赤小豆粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '薏米60g,赤小豆60g', '浸泡过夜；煮至豆软烂', '祛湿,粥品', '湿热质,痰湿质', 990, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (29, '芦笋炒虾仁', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800', '芦笋200g,虾仁150g', '芦笋切段焯水；与虾仁快炒调味', '低脂,优质蛋白', '平和质,气郁质', 880, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (30, '桂花糖藕', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800', '莲藕2节,糯米100g,桂花酱,红糖', '糯米灌藕孔；红糖水煮软；切片淋桂花', '甜品,传统', '血瘀质,平和质', 560, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (31, '五指毛桃茯苓鸡汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '土鸡半只,五指毛桃30g,茯苓15g,红枣5颗', '鸡块焯水；药材同炖1.5小时；少盐', '汤品,祛湿', '气虚质,痰湿质', 430, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (32, '肉桂苹果燕麦粥', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '燕麦80g,苹果1个,肉桂粉少许', '燕麦煮软；苹果丁与肉桂拌匀加入', '早餐,温阳', '阳虚质,气虚质', 360, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (33, '沙参玉竹老鸭汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '老鸭半只,沙参15g,玉竹15g', '老鸭焯水；与药材小火煲2小时', '滋阴,汤品', '阴虚质,平和质', 520, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (34, '荷叶山楂茶（代餐饮）', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800', '干荷叶5g,山楂干10g', '沸水冲泡焖10分钟', '茶饮,消脂', '痰湿质,湿热质', 280, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (35, '苦瓜黄豆排骨汤', 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800', '排骨300g,苦瓜1根,黄豆50g', '排骨焯水；与黄豆煮40分钟；下苦瓜煮15分钟', '清热,汤品', '湿热质,平和质', 410, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (36, '山楂红糖饮', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800', '山楂干15g,红糖适量', '山楂煮10分钟；加入红糖溶化', '饮品,化瘀', '血瘀质,气郁质', 190, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (37, '玫瑰花陈皮茶', 'https://images.unsplash.com/photo-1478144592103-25e218a04891?w=800', '玫瑰花6g,陈皮3g', '热水冲泡5分钟', '理气,茶饮', '气郁质,平和质', 240, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (38, '小米南瓜胡萝卜粥（低敏）', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '小米80g,南瓜100g,胡萝卜50g', '食材切丁同煮至绵软', '早餐,低敏', '特禀质,平和质', 310, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (39, '三色藜麦蔬菜沙拉', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '藜麦60g,生菜,番茄,橄榄油柠檬汁', '藜麦煮熟沥干；蔬菜拌匀', '轻食,均衡', '平和质,湿热质', 450, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `recipe` VALUES (40, '黄芪枸杞蒸蛋', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800', '鸡蛋2个,黄芪10g,枸杞10g', '蛋液与少量黄芪水搅匀；撒枸杞蒸10分钟', '补气,蛋白', '气虚质,血瘀质', 380, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');

-- ----------------------------
-- Table structure for regimen_plan
-- ----------------------------
DROP TABLE IF EXISTS `regimen_plan`;
CREATE TABLE `regimen_plan`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '方案ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方案名称',
  `plan_type` tinyint(1) NOT NULL COMMENT '方案类型:1-药膳,2-穴位按摩,3-运动建议',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方案内容',
  `suitable_constitution` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用体质(逗号分隔)',
  `suitable_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用等级(逗号分隔)',
  `tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-下架,1-上架',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调理方案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of regimen_plan
-- ----------------------------
INSERT INTO `regimen_plan` VALUES (1, '通用药膳调理', 1, '饮食宜清淡少油，多食当季蔬菜与优质蛋白；气虚者可适量山药、红枣、黄芪炖汤；阴虚者宜银耳、百合、梨；痰湿者少甜腻油炸，可薏米赤小豆粥。具体配伍请咨询执业中医师。', '平和质,气虚质,阳虚质,阴虚质,痰湿质,湿热质,血瘀质,气郁质,特禀质', '0,1,2,3', '药膳', 1, '2026-05-15 14:35:37', NULL);
INSERT INTO `regimen_plan` VALUES (2, '通用穴位保健', 2, '足三里（膝下3寸）健脾和胃；三阴交（内踝上3寸）调肝脾肾；内关（腕横纹上2寸）安神理气。每穴顺时针按揉1–2分钟，以酸胀为度，每日1–2次。孕妇慎用三阴交。', '平和质,气虚质,阳虚质,阴虚质,痰湿质,湿热质,血瘀质,气郁质,特禀质', '0,1,2,3', '穴位', 1, '2026-05-15 14:35:37', NULL);
INSERT INTO `regimen_plan` VALUES (3, '通用运动建议', 3, '每周至少150分钟中等强度有氧运动（快走、骑行、游泳择一）；配合八段锦或太极拳每周3次；久坐每45分钟起身活动5分钟。亚健康偏重时降低强度、以不气喘为度。', '平和质,气虚质,阳虚质,阴虚质,痰湿质,湿热质,血瘀质,气郁质,特禀质', '0,1,2,3', '运动', 1, '2026-05-15 14:35:37', NULL);

-- ----------------------------
-- Table structure for social_comment
-- ----------------------------
DROP TABLE IF EXISTS `social_comment`;
CREATE TABLE `social_comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` int NOT NULL COMMENT '动态ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `parent_id` int NULL DEFAULT 0 COMMENT '父评论ID(0表示一级评论)',
  `content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-正常,1-已删除',
  `create_time` datetime NOT NULL COMMENT '评论时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_social_comment_post` FOREIGN KEY (`post_id`) REFERENCES `social_post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_social_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 440 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '社交评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of social_comment
-- ----------------------------
INSERT INTO `social_comment` VALUES (301, 56, 57, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (302, 57, 7, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (303, 57, 56, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (304, 58, 8, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (305, 58, 57, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (306, 59, 9, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (307, 59, 58, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (308, 60, 10, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (309, 60, 59, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (310, 61, 11, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (311, 61, 60, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (312, 62, 12, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (313, 62, 61, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (314, 63, 13, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (315, 63, 62, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (316, 64, 14, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (317, 64, 63, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (318, 65, 15, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (319, 65, 64, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (320, 66, 16, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (321, 66, 65, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (322, 67, 17, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (323, 67, 66, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (324, 68, 18, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (325, 68, 67, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (326, 69, 19, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (327, 69, 68, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (328, 70, 20, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (329, 70, 69, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (330, 71, 21, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (331, 71, 70, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (332, 72, 22, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (333, 72, 71, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (334, 73, 23, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (335, 73, 72, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (336, 74, 24, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (337, 74, 73, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (338, 75, 25, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (339, 75, 74, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (340, 76, 26, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (341, 76, 75, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (342, 77, 27, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (343, 77, 76, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (344, 78, 28, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (345, 78, 77, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (346, 79, 29, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (347, 79, 78, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (348, 80, 30, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (349, 80, 79, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (350, 81, 31, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (351, 81, 80, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (352, 82, 32, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (353, 82, 81, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (354, 83, 33, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (355, 83, 82, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (356, 84, 34, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (357, 84, 83, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (358, 85, 35, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (359, 85, 84, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (360, 86, 36, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (361, 86, 85, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (362, 87, 37, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (363, 87, 86, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (364, 88, 38, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (365, 88, 87, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (366, 89, 39, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (367, 89, 88, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (368, 90, 40, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (369, 90, 89, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (370, 91, 41, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (371, 91, 90, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (372, 92, 42, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (373, 92, 91, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (374, 93, 43, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (375, 93, 92, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (376, 94, 44, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (377, 94, 93, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (378, 95, 45, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (379, 95, 94, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (380, 96, 46, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (381, 96, 95, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (382, 97, 47, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (383, 97, 96, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (384, 98, 48, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (385, 98, 97, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (386, 99, 49, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (387, 99, 98, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (390, 101, 51, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (392, 102, 52, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (393, 102, 101, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (394, 103, 53, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (395, 103, 102, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (396, 104, 54, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (397, 104, 103, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (398, 105, 55, 0, '一起加油！', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (399, 105, 104, 0, '注意饮食少油少盐', 0, '2026-05-16 12:00:00');
INSERT INTO `social_comment` VALUES (420, 1, 6, 0, 'HIIT节奏很棒，我也打算跟练！', 0, '2026-04-02 10:11:00');
INSERT INTO `social_comment` VALUES (421, 1, 6, 0, '出汗多记得补水～', 0, '2026-04-05 16:22:00');
INSERT INTO `social_comment` VALUES (422, 2, 6, 0, '小米粥暖胃，收藏了。', 0, '2026-04-03 08:05:00');
INSERT INTO `social_comment` VALUES (423, 2, 6, 0, '早上喝很舒服+1', 0, '2026-04-06 07:40:00');
INSERT INTO `social_comment` VALUES (424, 3, 6, 0, '八段锦对睡眠真的有帮助。', 0, '2026-04-04 21:18:00');
INSERT INTO `social_comment` VALUES (425, 3, 6, 0, '请问每天练几遍合适？', 0, '2026-04-07 19:30:00');
INSERT INTO `social_comment` VALUES (426, 4, 6, 0, '午休拉伸同款，肩颈松很多。', 0, '2026-04-08 12:12:00');
INSERT INTO `social_comment` VALUES (427, 4, 6, 0, '办公室必备技能哈哈', 0, '2026-04-10 12:50:00');
INSERT INTO `social_comment` VALUES (428, 5, 6, 0, '意面配鸡胸经典减脂餐。', 0, '2026-04-09 18:25:00');
INSERT INTO `social_comment` VALUES (429, 5, 6, 0, '番茄酱汁熬浓一点更香', 0, '2026-04-11 20:01:00');
INSERT INTO `social_comment` VALUES (430, 6, 6, 0, '早睡一周变化很明显，我也在试。', 0, '2026-04-12 22:08:00');
INSERT INTO `social_comment` VALUES (431, 6, 6, 0, '共勉，一起坚持', 0, '2026-04-14 07:55:00');
INSERT INTO `social_comment` VALUES (432, 7, 6, 0, '清蒸鱼清淡又营养，学习了。', 0, '2026-04-13 11:33:00');
INSERT INTO `social_comment` VALUES (433, 7, 6, 0, '配菜可以多来点西兰花', 0, '2026-04-15 12:10:00');
INSERT INTO `social_comment` VALUES (434, 8, 6, 0, '配速提升不容易，厉害！', 0, '2026-04-16 06:45:00');
INSERT INTO `social_comment` VALUES (435, 8, 6, 0, '跑步注意膝盖热身', 0, '2026-04-18 20:20:00');
INSERT INTO `social_comment` VALUES (436, 9, 6, 0, '气虚质朋友可以试试循序渐进。', 0, '2026-04-17 09:12:00');
INSERT INTO `social_comment` VALUES (437, 10, 6, 0, '薏米赤小豆粥我也常喝，祛湿不错。', 0, '2026-04-19 17:28:00');
INSERT INTO `social_comment` VALUES (438, 11, 6, 0, '徒步风景真好，羡慕好天气。', 0, '2026-04-20 15:00:00');
INSERT INTO `social_comment` VALUES (439, 12, 6, 0, '低盐饮食对血压友好，加油！', 0, '2026-04-21 10:06:00');

-- ----------------------------
-- Table structure for social_post
-- ----------------------------
DROP TABLE IF EXISTS `social_post`;
CREATE TABLE `social_post`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '动态ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文字内容',
  `images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL(逗号分隔)',
  `tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题标签',
  `like_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT 0 COMMENT '评论数',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '审核状态:0-待审核,1-已通过,2-已驳回,3-已删除',
  `reject_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `create_time` datetime NOT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_social_post_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '社交动态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of social_post
-- ----------------------------
INSERT INTO `social_post` VALUES (1, 2, '今天完成了12分钟HIIT，出汗超爽！', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800', '#减脂,#打卡', 26, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (2, 3, '山药小米粥真适合早起胃口差的时候。', NULL, '#早餐,#养胃', 19, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (3, 4, '八段锦练了两周，睡眠明显好了很多。', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800', '#中医养生,#睡眠', 34, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (4, 5, '办公室久坐党，午休拉伸10分钟太有用了。', NULL, '#拉伸,#久坐', 22, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (5, 2, '番茄鸡胸意面当晚餐，饱腹又不油腻。', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800', '#健康食谱,#低脂', 28, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (6, 3, '坚持早睡一周后，晨起精神好多了，推荐大家也试试。', NULL, '#睡眠,#习惯', 15, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (7, 4, '分享今日午餐：清蒸鱼配时蔬，清淡又营养。', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800', '#轻食,#午餐', 21, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (8, 5, '跑步5公里打卡，配速比上周快了30秒！', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800', '#跑步,#打卡', 33, 2, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (9, 2, '气虚质的朋友可以试试八段锦，动作温和很适合。', NULL, '#气虚质,#养生', 18, 1, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (10, 3, '自制薏米赤小豆粥，祛湿效果不错。', 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800', '#祛湿,#食谱', 24, 1, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (11, 4, '周末徒步10公里，风景好空气也好。', 'https://images.unsplash.com/photo-1551632811-561732d1e9ed?w=800', '#户外,#有氧', 29, 1, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (12, 5, '最近血压控制得不错，继续保持低盐饮食。', NULL, '#血压,#健康', 12, 1, 1, NULL, '2026-05-15 14:35:38');
INSERT INTO `social_post` VALUES (13, 6, '三月第一周：减脂有氧六练完成，开合跳深蹲胯下击掌全套打卡。', NULL, '#减脂,#有氧,#打卡', 3, 0, 1, NULL, '2026-03-08 20:10:00');
INSERT INTO `social_post` VALUES (14, 6, '早餐改燕麦鸡蛋，午餐少油多蔬菜，体重稳步下降中。', NULL, '#饮食,#减脂', 2, 0, 1, NULL, '2026-03-15 12:30:00');
INSERT INTO `social_post` VALUES (15, 6, '力量日：周一胸日一小时，推胸和上斜都有进步。', NULL, '#增肌,#练胸', 4, 0, 1, NULL, '2026-03-17 21:00:00');
INSERT INTO `social_post` VALUES (16, 6, '自制清蒸鱼配杂粮饭，控盐控油，练后补充蛋白。', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800', '#饮食,#高蛋白', 5, 0, 1, NULL, '2026-03-22 19:15:00');
INSERT INTO `social_post` VALUES (17, 6, '周日放松走：操场慢走一小时，心率平稳很舒服。', NULL, '#放松,#慢走', 2, 0, 1, NULL, '2026-03-23 18:00:00');
INSERT INTO `social_post` VALUES (18, 6, '四月打卡：周三练腿日深蹲硬拉完成，记得拉伸。', NULL, '#增肌,#练腿', 3, 0, 1, NULL, '2026-04-09 20:45:00');
INSERT INTO `social_post` VALUES (19, 6, '外食选了清汤火锅多涮菜，少蘸料，减脂期也能社交。', NULL, '#饮食,#外食', 6, 0, 1, NULL, '2026-04-16 13:20:00');
INSERT INTO `social_post` VALUES (20, 6, '有氧日组合100+100+100完成，汗透但很爽。', NULL, '#有氧,#打卡', 4, 0, 1, NULL, '2026-04-23 20:05:00');
INSERT INTO `social_post` VALUES (21, 6, '五月上旬：体重已接近目标区间，继续保持力量训练频率。', NULL, '#减脂,#阶段总结', 7, 0, 1, NULL, '2026-05-05 09:00:00');
INSERT INTO `social_post` VALUES (22, 6, '今日练背引体辅助+划船，练后补充香蕉和酸奶。', NULL, '#增肌,#练背,#饮食', 5, 0, 1, NULL, '2026-05-12 21:30:00');
INSERT INTO `social_post` VALUES (56, 56, '坚持运动第1天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-01 18:00:00');
INSERT INTO `social_post` VALUES (57, 57, '坚持运动第2天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-02 18:00:00');
INSERT INTO `social_post` VALUES (58, 58, '坚持运动第3天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-03 18:00:00');
INSERT INTO `social_post` VALUES (59, 59, '坚持运动第4天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-04 18:00:00');
INSERT INTO `social_post` VALUES (60, 60, '坚持运动第5天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 6, 2, 1, NULL, '2026-05-05 18:00:00');
INSERT INTO `social_post` VALUES (61, 61, '坚持运动第6天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-06 18:00:00');
INSERT INTO `social_post` VALUES (62, 62, '坚持运动第7天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-07 18:00:00');
INSERT INTO `social_post` VALUES (63, 63, '坚持运动第8天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-08 18:00:00');
INSERT INTO `social_post` VALUES (64, 64, '坚持运动第9天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-09 18:00:00');
INSERT INTO `social_post` VALUES (65, 65, '坚持运动第10天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-10 18:00:00');
INSERT INTO `social_post` VALUES (66, 66, '坚持运动第11天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-11 18:00:00');
INSERT INTO `social_post` VALUES (67, 67, '坚持运动第12天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-12 18:00:00');
INSERT INTO `social_post` VALUES (68, 68, '坚持运动第13天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 6, 2, 1, NULL, '2026-05-13 18:00:00');
INSERT INTO `social_post` VALUES (69, 69, '坚持运动第14天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-14 18:00:00');
INSERT INTO `social_post` VALUES (70, 70, '坚持运动第15天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-15 18:00:00');
INSERT INTO `social_post` VALUES (71, 71, '坚持运动第16天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-16 18:00:00');
INSERT INTO `social_post` VALUES (72, 72, '坚持运动第17天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-17 18:00:00');
INSERT INTO `social_post` VALUES (73, 73, '坚持运动第18天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-18 18:00:00');
INSERT INTO `social_post` VALUES (74, 74, '坚持运动第19天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-19 18:00:00');
INSERT INTO `social_post` VALUES (75, 75, '坚持运动第20天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-20 18:00:00');
INSERT INTO `social_post` VALUES (76, 76, '坚持运动第21天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 6, 2, 1, NULL, '2026-05-21 18:00:00');
INSERT INTO `social_post` VALUES (77, 77, '坚持运动第22天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-22 18:00:00');
INSERT INTO `social_post` VALUES (78, 78, '坚持运动第23天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-23 18:00:00');
INSERT INTO `social_post` VALUES (79, 79, '坚持运动第24天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-24 18:00:00');
INSERT INTO `social_post` VALUES (80, 80, '坚持运动第25天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-25 18:00:00');
INSERT INTO `social_post` VALUES (81, 81, '坚持运动第26天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-01 18:00:00');
INSERT INTO `social_post` VALUES (82, 82, '坚持运动第27天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-02 18:00:00');
INSERT INTO `social_post` VALUES (83, 83, '坚持运动第28天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-03 18:00:00');
INSERT INTO `social_post` VALUES (84, 84, '坚持运动第29天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 6, 2, 1, NULL, '2026-05-04 18:00:00');
INSERT INTO `social_post` VALUES (85, 85, '坚持运动第30天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-05 18:00:00');
INSERT INTO `social_post` VALUES (86, 86, '坚持运动第31天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-06 18:00:00');
INSERT INTO `social_post` VALUES (87, 87, '坚持运动第32天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-07 18:00:00');
INSERT INTO `social_post` VALUES (88, 88, '坚持运动第33天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-08 18:00:00');
INSERT INTO `social_post` VALUES (89, 89, '坚持运动第34天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-09 18:00:00');
INSERT INTO `social_post` VALUES (90, 90, '坚持运动第35天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-10 18:00:00');
INSERT INTO `social_post` VALUES (91, 91, '坚持运动第36天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-11 18:00:00');
INSERT INTO `social_post` VALUES (92, 92, '坚持运动第37天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 6, 2, 1, NULL, '2026-05-12 18:00:00');
INSERT INTO `social_post` VALUES (93, 93, '坚持运动第38天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-13 18:00:00');
INSERT INTO `social_post` VALUES (94, 94, '坚持运动第39天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-14 18:00:00');
INSERT INTO `social_post` VALUES (95, 95, '坚持运动第40天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-15 18:00:00');
INSERT INTO `social_post` VALUES (96, 96, '坚持运动第41天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-16 18:00:00');
INSERT INTO `social_post` VALUES (97, 97, '坚持运动第42天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-17 18:00:00');
INSERT INTO `social_post` VALUES (98, 98, '坚持运动第43天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 4, 2, 1, NULL, '2026-05-18 18:00:00');
INSERT INTO `social_post` VALUES (99, 99, '坚持运动第44天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 5, 2, 1, NULL, '2026-05-19 18:00:00');
INSERT INTO `social_post` VALUES (101, 101, '坚持运动第46天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 7, 2, 1, NULL, '2026-05-21 18:00:00');
INSERT INTO `social_post` VALUES (102, 102, '坚持运动第47天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 8, 2, 1, NULL, '2026-05-22 18:00:00');
INSERT INTO `social_post` VALUES (103, 103, '坚持运动第48天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 9, 2, 1, NULL, '2026-05-23 18:00:00');
INSERT INTO `social_post` VALUES (104, 104, '坚持运动第49天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 2, 2, 1, NULL, '2026-05-24 18:00:00');
INSERT INTO `social_post` VALUES (105, 105, '坚持运动第50天，配合饮食调理，感觉精力更好了！', NULL, '#打卡,#养生', 3, 2, 1, NULL, '2026-05-25 18:00:00');
INSERT INTO `social_post` VALUES (106, 6, '哈哈哈哈和', NULL, '健康', 0, 0, 3, NULL, '2026-05-15 18:59:59');
INSERT INTO `social_post` VALUES (107, 6, '111', NULL, NULL, 0, 0, 3, NULL, '2026-05-18 00:45:42');
INSERT INTO `social_post` VALUES (108, 6, '111', NULL, NULL, 0, 0, 1, NULL, '2026-05-18 00:57:05');
INSERT INTO `social_post` VALUES (109, 6, 'wwww', NULL, NULL, 0, 0, 1, NULL, '2026-05-18 01:03:37');

-- ----------------------------
-- Table structure for sport_plan
-- ----------------------------
DROP TABLE IF EXISTS `sport_plan`;
CREATE TABLE `sport_plan`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '计划ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `goal_type` tinyint(1) NOT NULL COMMENT '目标类型:1-减脂,2-增肌,3-缓解压力',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `frequency` int NOT NULL COMMENT '每周次数',
  `duration` int NOT NULL COMMENT '每次时长(分钟)',
  `plan_content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计划说明或扩展JSON',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-进行中,1-已完成,2-已放弃',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_sport_plan_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运动计划表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sport_plan
-- ----------------------------
INSERT INTO `sport_plan` VALUES (1, 1, 1, '2026-04-15', '2026-07-15', 3, 30, '晨间HIIT减脂计划：每周一三五，结合推荐视频完成燃脂训练', 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `sport_plan` VALUES (2, 2, 2, '2026-04-10', '2026-07-10', 4, 45, '增肌塑形计划：核心+哑铃训练，每周四次力量循环', 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `sport_plan` VALUES (3, 3, 3, '2026-04-20', '2026-07-20', 3, 25, '减压舒缓计划：八段锦与呼吸冥想，改善睡眠与情绪', 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `sport_plan` VALUES (4, 4, 1, '2026-05-01', '2026-08-01', 3, 25, '低冲击有氧减脂：快走+拉伸，适合久坐办公人群', 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `sport_plan` VALUES (5, 5, 1, '2026-04-01', '2026-06-30', 5, 40, '跑步进阶计划：每周五次，逐步提升配速与耐力', 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `sport_plan` VALUES (6, 6, 1, '2026-03-01', '2026-08-31', 6, 60, '{\"exerciseForm\":\"有氧训练\",\"exerciseSchedule\":\"每周六次，周一到周六；打卡日为周一至周六（周日休息）\",\"exerciseDetail\":\"100个开合跳、100个深蹲、100个胯下击掌\",\"remindEnabled\":true,\"remindTime\":\"20:00\",\"intensityLevel\":2}', 0, '2026-05-15 18:11:03', '2026-05-15 18:11:03');
INSERT INTO `sport_plan` VALUES (7, 6, 2, '2026-03-01', '2026-08-31', 3, 60, '{\"exerciseForm\":\"力量训练\",\"exerciseSchedule\":\"一周三练：周一练胸、周二练背、周三练腿与手臂；打卡为每周一、二、三\",\"exerciseDetail\":\"健身房分化训练，单次约一小时\",\"remindEnabled\":true,\"remindTime\":\"17:00\",\"intensityLevel\":3}', 0, '2026-05-15 18:11:03', '2026-05-15 18:11:03');
INSERT INTO `sport_plan` VALUES (8, 6, 3, '2026-03-01', '2026-08-31', 1, 60, '{\"exerciseForm\":\"慢走\",\"exerciseSchedule\":\"每周一次，周日操场散步一小时\",\"exerciseDetail\":\"绕操场慢走一小时，放松为主\",\"remindEnabled\":false,\"remindTime\":null,\"intensityLevel\":1}', 0, '2026-05-15 18:11:03', '2026-05-15 18:11:03');
INSERT INTO `sport_plan` VALUES (60, 200, 1, '2026-03-01', '2026-08-31', 6, 60, '{\"exerciseForm\":\"有氧训练\",\"exerciseSchedule\":\"每周六次，周一到周六；打卡日为周一至周六（周日休息）\",\"exerciseDetail\":\"100个开合跳、100个深蹲、100个胯下击掌\",\"remindEnabled\":true,\"remindTime\":\"20:00\",\"intensityLevel\":2}', 0, '2026-05-15 16:26:27', '2026-05-15 16:26:27');
INSERT INTO `sport_plan` VALUES (61, 200, 2, '2026-03-01', '2026-08-31', 3, 60, '{\"exerciseForm\":\"力量训练\",\"exerciseSchedule\":\"一周三练：周一练胸、周二练背、周三练腿与手臂；打卡为每周一、二、三\",\"exerciseDetail\":\"健身房分化训练，单次约一小时\",\"remindEnabled\":true,\"remindTime\":\"17:00\",\"intensityLevel\":3}', 0, '2026-05-15 16:26:27', '2026-05-15 16:26:27');
INSERT INTO `sport_plan` VALUES (62, 200, 3, '2026-03-01', '2026-08-31', 1, 60, '{\"exerciseForm\":\"慢走\",\"exerciseSchedule\":\"每周一次，周日操场散步一小时\",\"exerciseDetail\":\"绕操场慢走一小时，放松为主\",\"remindEnabled\":false,\"remindTime\":null,\"intensityLevel\":1}', 0, '2026-05-15 16:26:27', '2026-05-15 16:26:27');
INSERT INTO `sport_plan` VALUES (101, 7, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (102, 8, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (103, 9, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (104, 10, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (105, 11, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (106, 12, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (107, 13, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (108, 14, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (109, 15, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (110, 16, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (111, 17, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (112, 18, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (113, 19, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (114, 20, 3, '2026-04-05', '2026-06-30', 5, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (115, 21, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (116, 22, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (117, 23, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (118, 24, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (119, 25, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (120, 26, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (121, 27, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (122, 28, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (123, 29, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (124, 30, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (125, 31, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (126, 32, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (127, 33, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (128, 34, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (129, 35, 3, '2026-04-05', '2026-06-30', 5, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (130, 36, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (131, 37, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (132, 38, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (133, 39, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (134, 40, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (135, 41, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (136, 42, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (137, 43, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (138, 44, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (139, 45, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (140, 46, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (141, 47, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (142, 48, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (143, 49, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (144, 50, 3, '2026-04-05', '2026-06-30', 5, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (145, 51, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (146, 52, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (147, 53, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (148, 54, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (149, 55, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (150, 56, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (151, 57, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (152, 58, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (153, 59, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (154, 60, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (155, 61, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (156, 62, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (157, 63, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (158, 64, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (159, 65, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (160, 66, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (161, 67, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (162, 68, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (163, 69, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (164, 70, 3, '2026-04-05', '2026-06-30', 5, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (165, 71, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (166, 72, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (167, 73, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (168, 74, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (169, 75, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (170, 76, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (171, 77, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (172, 78, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (173, 79, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (174, 80, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (175, 81, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (176, 82, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (177, 83, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (178, 84, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (179, 85, 3, '2026-04-05', '2026-06-30', 5, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (180, 86, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (181, 87, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (182, 88, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (183, 89, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (184, 90, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (185, 91, 3, '2026-04-05', '2026-06-30', 5, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (186, 92, 1, '2026-04-05', '2026-06-30', 3, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (187, 93, 2, '2026-04-05', '2026-06-30', 4, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (188, 94, 3, '2026-04-05', '2026-06-30', 5, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (189, 95, 1, '2026-04-05', '2026-06-30', 3, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (190, 96, 2, '2026-04-05', '2026-06-30', 4, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (191, 97, 3, '2026-04-05', '2026-06-30', 5, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (192, 98, 1, '2026-04-05', '2026-06-30', 3, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (193, 99, 2, '2026-04-05', '2026-06-30', 4, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (195, 101, 1, '2026-04-05', '2026-06-30', 3, 20, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (196, 102, 2, '2026-04-05', '2026-06-30', 4, 25, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (197, 103, 3, '2026-04-05', '2026-06-30', 5, 30, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (198, 104, 1, '2026-04-05', '2026-06-30', 3, 35, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');
INSERT INTO `sport_plan` VALUES (199, 105, 2, '2026-04-05', '2026-06-30', 4, 40, '每周打卡，结合体质与调理方案执行', 0, '2026-04-10 08:00:00', '2026-04-10 08:00:00');

-- ----------------------------
-- Table structure for sport_record
-- ----------------------------
DROP TABLE IF EXISTS `sport_record`;
CREATE TABLE `sport_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `plan_id` int NOT NULL COMMENT '计划ID',
  `record_date` date NOT NULL COMMENT '打卡日期',
  `duration` int NOT NULL COMMENT '运动时长(分钟)',
  `calories` int NULL DEFAULT NULL COMMENT '消耗热量(千卡)',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-未完成,1-已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actual_duration` int NOT NULL COMMENT '实际运动时长(分钟)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_plan_id`(`plan_id` ASC) USING BTREE,
  CONSTRAINT `fk_sport_record_plan` FOREIGN KEY (`plan_id`) REFERENCES `sport_plan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sport_record_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 437 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运动打卡记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sport_record
-- ----------------------------
INSERT INTO `sport_record` VALUES (1, 1, 1, '2026-04-21', 30, 180, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 28);
INSERT INTO `sport_record` VALUES (2, 1, 1, '2026-04-23', 30, 195, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 32);
INSERT INTO `sport_record` VALUES (3, 1, 1, '2026-04-28', 30, 170, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 25);
INSERT INTO `sport_record` VALUES (4, 1, 1, '2026-05-05', 30, 188, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 30);
INSERT INTO `sport_record` VALUES (5, 1, 1, '2026-05-12', 30, 200, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 35);
INSERT INTO `sport_record` VALUES (6, 2, 2, '2026-04-14', 45, 220, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 42);
INSERT INTO `sport_record` VALUES (7, 2, 2, '2026-04-16', 45, 235, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 48);
INSERT INTO `sport_record` VALUES (8, 2, 2, '2026-04-21', 45, 210, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 40);
INSERT INTO `sport_record` VALUES (9, 2, 2, '2026-05-03', 45, 245, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 50);
INSERT INTO `sport_record` VALUES (10, 2, 2, '2026-05-10', 45, 228, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 44);
INSERT INTO `sport_record` VALUES (11, 3, 3, '2026-04-25', 25, 95, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 22);
INSERT INTO `sport_record` VALUES (12, 3, 3, '2026-04-28', 25, 88, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 20);
INSERT INTO `sport_record` VALUES (13, 3, 3, '2026-05-06', 25, 102, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 28);
INSERT INTO `sport_record` VALUES (14, 3, 3, '2026-05-13', 25, 90, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 24);
INSERT INTO `sport_record` VALUES (15, 4, 4, '2026-05-06', 25, 120, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 23);
INSERT INTO `sport_record` VALUES (16, 4, 4, '2026-05-09', 25, 135, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 27);
INSERT INTO `sport_record` VALUES (17, 4, 4, '2026-05-12', 25, 128, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 26);
INSERT INTO `sport_record` VALUES (18, 5, 5, '2026-05-01', 40, 320, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 38);
INSERT INTO `sport_record` VALUES (19, 5, 5, '2026-05-05', 40, 340, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 42);
INSERT INTO `sport_record` VALUES (20, 5, 5, '2026-05-08', 40, 310, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 36);
INSERT INTO `sport_record` VALUES (21, 5, 5, '2026-05-12', 40, 355, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 45);
INSERT INTO `sport_record` VALUES (22, 5, 5, '2026-05-14', 40, 330, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38', 40);
INSERT INTO `sport_record` VALUES (23, 6, 6, '2026-03-02', 60, 420, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (24, 6, 6, '2026-03-03', 60, 435, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (25, 6, 6, '2026-03-04', 60, 428, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 59);
INSERT INTO `sport_record` VALUES (26, 6, 6, '2026-03-05', 60, 440, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 62);
INSERT INTO `sport_record` VALUES (27, 6, 6, '2026-03-06', 60, 432, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 61);
INSERT INTO `sport_record` VALUES (28, 6, 6, '2026-03-07', 60, 425, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 57);
INSERT INTO `sport_record` VALUES (29, 6, 6, '2026-03-09', 60, 438, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (30, 6, 6, '2026-03-10', 60, 430, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 59);
INSERT INTO `sport_record` VALUES (31, 6, 6, '2026-03-11', 60, 445, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 63);
INSERT INTO `sport_record` VALUES (32, 6, 6, '2026-03-12', 60, 418, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 55);
INSERT INTO `sport_record` VALUES (33, 6, 6, '2026-04-07', 60, 450, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (34, 6, 6, '2026-04-28', 60, 440, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (35, 6, 7, '2026-03-02', 60, 280, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (36, 6, 7, '2026-03-03', 60, 290, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (37, 6, 7, '2026-03-04', 60, 310, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 62);
INSERT INTO `sport_record` VALUES (38, 6, 7, '2026-03-09', 60, 275, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 57);
INSERT INTO `sport_record` VALUES (39, 6, 7, '2026-03-10', 60, 285, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 59);
INSERT INTO `sport_record` VALUES (40, 6, 7, '2026-03-11', 60, 300, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 61);
INSERT INTO `sport_record` VALUES (41, 6, 7, '2026-03-16', 60, 288, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (42, 6, 7, '2026-03-17', 60, 292, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (43, 6, 7, '2026-03-18', 60, 305, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 62);
INSERT INTO `sport_record` VALUES (44, 6, 8, '2026-03-08', 60, 180, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (45, 6, 8, '2026-03-15', 60, 175, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (46, 6, 8, '2026-03-22', 60, 182, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 61);
INSERT INTO `sport_record` VALUES (47, 6, 8, '2026-03-29', 60, 178, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 59);
INSERT INTO `sport_record` VALUES (48, 6, 8, '2026-04-05', 60, 185, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (49, 6, 8, '2026-04-12', 60, 172, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 56);
INSERT INTO `sport_record` VALUES (50, 6, 8, '2026-04-19', 60, 180, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (51, 6, 8, '2026-04-26', 60, 176, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 58);
INSERT INTO `sport_record` VALUES (52, 6, 8, '2026-05-03', 60, 181, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 59);
INSERT INTO `sport_record` VALUES (53, 6, 8, '2026-05-10', 60, 179, 1, '2026-05-15 18:11:03', '2026-05-15 18:11:03', 60);
INSERT INTO `sport_record` VALUES (103, 7, 101, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (104, 7, 101, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (105, 7, 101, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (106, 8, 102, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (107, 8, 102, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (108, 8, 102, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (109, 9, 103, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (110, 9, 103, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (111, 9, 103, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (112, 10, 104, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (113, 10, 104, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (114, 10, 104, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (115, 11, 105, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (116, 11, 105, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (117, 11, 105, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (118, 12, 106, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (119, 12, 106, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (120, 12, 106, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (121, 13, 107, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (122, 13, 107, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (123, 13, 107, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (124, 14, 108, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (125, 14, 108, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (126, 14, 108, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (127, 15, 109, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (128, 15, 109, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (129, 15, 109, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (130, 16, 110, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (131, 16, 110, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (132, 16, 110, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (133, 17, 111, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (134, 17, 111, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (135, 17, 111, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (136, 18, 112, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (137, 18, 112, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (138, 18, 112, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (139, 19, 113, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (140, 19, 113, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (141, 19, 113, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (142, 20, 114, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (143, 20, 114, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (144, 20, 114, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (145, 21, 115, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (146, 21, 115, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (147, 21, 115, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (148, 22, 116, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (149, 22, 116, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (150, 22, 116, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (151, 23, 117, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (152, 23, 117, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (153, 23, 117, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (154, 24, 118, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (155, 24, 118, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (156, 24, 118, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (157, 25, 119, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (158, 25, 119, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (159, 25, 119, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (160, 26, 120, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (161, 26, 120, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (162, 26, 120, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (163, 27, 121, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (164, 27, 121, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (165, 27, 121, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (166, 28, 122, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (167, 28, 122, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (168, 28, 122, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (169, 29, 123, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (170, 29, 123, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (171, 29, 123, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (172, 30, 124, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (173, 30, 124, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (174, 30, 124, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (175, 31, 125, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (176, 31, 125, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (177, 31, 125, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (178, 32, 126, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (179, 32, 126, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (180, 32, 126, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (181, 33, 127, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (182, 33, 127, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (183, 33, 127, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (184, 34, 128, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (185, 34, 128, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (186, 34, 128, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (187, 35, 129, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (188, 35, 129, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (189, 35, 129, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (190, 36, 130, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (191, 36, 130, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (192, 36, 130, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (193, 37, 131, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (194, 37, 131, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (195, 37, 131, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (196, 38, 132, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (197, 38, 132, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (198, 38, 132, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (199, 39, 133, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (200, 39, 133, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (201, 39, 133, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (202, 40, 134, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (203, 40, 134, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (204, 40, 134, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (205, 41, 135, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (206, 41, 135, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (207, 41, 135, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (208, 42, 136, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (209, 42, 136, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (210, 42, 136, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (211, 43, 137, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (212, 43, 137, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (213, 43, 137, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (214, 44, 138, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (215, 44, 138, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (216, 44, 138, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (217, 45, 139, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (218, 45, 139, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (219, 45, 139, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (220, 46, 140, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (221, 46, 140, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (222, 46, 140, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (223, 47, 141, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (224, 47, 141, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (225, 47, 141, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (226, 48, 142, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (227, 48, 142, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (228, 48, 142, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (229, 49, 143, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (230, 49, 143, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (231, 49, 143, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (232, 50, 144, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (233, 50, 144, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (234, 50, 144, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (235, 51, 145, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (236, 51, 145, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (237, 51, 145, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (238, 52, 146, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (239, 52, 146, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (240, 52, 146, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (241, 53, 147, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (242, 53, 147, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (243, 53, 147, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (244, 54, 148, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (245, 54, 148, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (246, 54, 148, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (247, 55, 149, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (248, 55, 149, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (249, 55, 149, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (250, 56, 150, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (251, 56, 150, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (252, 56, 150, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (253, 57, 151, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (254, 57, 151, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (255, 57, 151, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (256, 58, 152, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (257, 58, 152, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (258, 58, 152, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (259, 59, 153, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (260, 59, 153, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (261, 59, 153, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (262, 60, 154, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (263, 60, 154, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (264, 60, 154, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (265, 61, 155, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (266, 61, 155, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (267, 61, 155, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (268, 62, 156, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (269, 62, 156, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (270, 62, 156, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (271, 63, 157, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (272, 63, 157, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (273, 63, 157, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (274, 64, 158, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (275, 64, 158, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (276, 64, 158, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (277, 65, 159, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (278, 65, 159, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (279, 65, 159, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (280, 66, 160, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (281, 66, 160, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (282, 66, 160, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (283, 67, 161, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (284, 67, 161, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (285, 67, 161, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (286, 68, 162, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (287, 68, 162, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (288, 68, 162, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (289, 69, 163, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (290, 69, 163, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (291, 69, 163, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (292, 70, 164, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (293, 70, 164, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (294, 70, 164, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (295, 71, 165, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (296, 71, 165, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (297, 71, 165, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (298, 72, 166, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (299, 72, 166, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (300, 72, 166, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (301, 73, 167, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (302, 73, 167, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (303, 73, 167, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (304, 74, 168, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (305, 74, 168, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (306, 74, 168, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (307, 75, 169, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (308, 75, 169, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (309, 75, 169, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (310, 76, 170, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (311, 76, 170, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (312, 76, 170, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (313, 77, 171, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (314, 77, 171, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (315, 77, 171, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (316, 78, 172, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (317, 78, 172, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (318, 78, 172, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (319, 79, 173, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (320, 79, 173, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (321, 79, 173, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (322, 80, 174, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (323, 80, 174, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (324, 80, 174, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (325, 81, 175, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (326, 81, 175, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (327, 81, 175, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (328, 82, 176, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (329, 82, 176, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (330, 82, 176, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (331, 83, 177, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (332, 83, 177, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (333, 83, 177, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (334, 84, 178, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (335, 84, 178, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (336, 84, 178, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (337, 85, 179, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (338, 85, 179, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (339, 85, 179, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (340, 86, 180, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (341, 86, 180, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (342, 86, 180, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (343, 87, 181, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (344, 87, 181, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (345, 87, 181, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (346, 88, 182, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (347, 88, 182, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (348, 88, 182, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (349, 89, 183, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (350, 89, 183, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (351, 89, 183, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (352, 90, 184, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (353, 90, 184, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (354, 90, 184, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (355, 91, 185, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (356, 91, 185, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (357, 91, 185, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (358, 92, 186, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (359, 92, 186, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (360, 92, 186, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (361, 93, 187, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (362, 93, 187, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (363, 93, 187, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (364, 94, 188, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (365, 94, 188, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (366, 94, 188, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (367, 95, 189, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (368, 95, 189, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (369, 95, 189, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (370, 96, 190, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (371, 96, 190, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (372, 96, 190, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (373, 97, 191, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (374, 97, 191, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (375, 97, 191, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (376, 98, 192, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (377, 98, 192, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (378, 98, 192, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (379, 99, 193, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (380, 99, 193, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (381, 99, 193, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (385, 101, 195, '2026-04-10', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (386, 101, 195, '2026-04-11', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (387, 101, 195, '2026-04-12', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (388, 102, 196, '2026-04-11', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (389, 102, 196, '2026-04-12', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (390, 102, 196, '2026-04-13', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (391, 103, 197, '2026-04-12', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (392, 103, 197, '2026-04-13', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (393, 103, 197, '2026-04-14', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (394, 104, 198, '2026-04-13', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (395, 104, 198, '2026-04-14', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (396, 104, 198, '2026-04-15', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (397, 105, 199, '2026-04-14', 25, 125, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 25);
INSERT INTO `sport_record` VALUES (398, 105, 199, '2026-04-15', 30, 150, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 30);
INSERT INTO `sport_record` VALUES (399, 105, 199, '2026-04-16', 35, 175, 1, '2026-04-11 07:00:00', '2026-04-11 07:00:00', 35);
INSERT INTO `sport_record` VALUES (400, 200, 60, '2026-03-02', 60, 420, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (401, 200, 60, '2026-03-03', 60, 435, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (402, 200, 60, '2026-03-04', 60, 428, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 59);
INSERT INTO `sport_record` VALUES (403, 200, 60, '2026-03-05', 60, 440, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 62);
INSERT INTO `sport_record` VALUES (404, 200, 60, '2026-03-06', 60, 432, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 61);
INSERT INTO `sport_record` VALUES (405, 200, 60, '2026-03-07', 60, 425, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 57);
INSERT INTO `sport_record` VALUES (406, 200, 60, '2026-03-09', 60, 438, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (407, 200, 60, '2026-03-10', 60, 430, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 59);
INSERT INTO `sport_record` VALUES (408, 200, 60, '2026-03-11', 60, 445, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 63);
INSERT INTO `sport_record` VALUES (409, 200, 60, '2026-03-12', 60, 418, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 55);
INSERT INTO `sport_record` VALUES (410, 200, 60, '2026-04-07', 60, 450, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (411, 200, 60, '2026-04-28', 60, 440, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (412, 200, 61, '2026-03-02', 60, 280, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (413, 200, 61, '2026-03-03', 60, 290, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (414, 200, 61, '2026-03-04', 60, 310, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 62);
INSERT INTO `sport_record` VALUES (415, 200, 61, '2026-03-09', 60, 275, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 57);
INSERT INTO `sport_record` VALUES (416, 200, 61, '2026-03-10', 60, 285, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 59);
INSERT INTO `sport_record` VALUES (417, 200, 61, '2026-03-11', 60, 300, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 61);
INSERT INTO `sport_record` VALUES (418, 200, 61, '2026-03-16', 60, 288, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (419, 200, 61, '2026-03-17', 60, 292, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (420, 200, 61, '2026-03-18', 60, 305, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 62);
INSERT INTO `sport_record` VALUES (421, 200, 62, '2026-03-08', 60, 180, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (422, 200, 62, '2026-03-15', 60, 175, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (423, 200, 62, '2026-03-22', 60, 182, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 61);
INSERT INTO `sport_record` VALUES (424, 200, 62, '2026-03-29', 60, 178, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 59);
INSERT INTO `sport_record` VALUES (425, 200, 62, '2026-04-05', 60, 185, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (426, 200, 62, '2026-04-12', 60, 172, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 56);
INSERT INTO `sport_record` VALUES (427, 200, 62, '2026-04-19', 60, 180, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (428, 200, 62, '2026-04-26', 60, 176, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 58);
INSERT INTO `sport_record` VALUES (429, 200, 62, '2026-05-03', 60, 181, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 59);
INSERT INTO `sport_record` VALUES (430, 200, 62, '2026-05-10', 60, 179, 1, '2026-05-15 16:26:27', '2026-05-15 16:26:27', 60);
INSERT INTO `sport_record` VALUES (431, 6, 8, '2026-05-15', 0, 323, 1, '2026-05-15 19:29:22', '2026-05-15 19:29:22', 60);
INSERT INTO `sport_record` VALUES (432, 6, 8, '2026-05-17', 0, 323, 1, '2026-05-17 23:53:11', '2026-05-17 23:53:11', 60);
INSERT INTO `sport_record` VALUES (433, 6, 6, '2026-05-15', 0, 485, 1, '2026-05-17 23:53:24', '2026-05-17 23:53:24', 60);
INSERT INTO `sport_record` VALUES (434, 6, 6, '2026-05-16', 0, 485, 1, '2026-05-17 23:53:45', '2026-05-17 23:53:45', 60);
INSERT INTO `sport_record` VALUES (435, 6, 8, '2026-05-16', 0, 323, 1, '2026-05-17 23:54:13', '2026-05-17 23:54:13', 60);
INSERT INTO `sport_record` VALUES (436, 6, 6, '2026-05-17', 0, 485, 1, '2026-05-17 23:57:08', '2026-05-17 23:57:08', 60);

-- ----------------------------
-- Table structure for subhealth_assessment_scale
-- ----------------------------
DROP TABLE IF EXISTS `subhealth_assessment_scale`;
CREATE TABLE `subhealth_assessment_scale`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `type_code` tinyint NOT NULL COMMENT '类型编码:1-生理指标,2-心理状态,3-生活习惯',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型名称',
  `question_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题号',
  `question_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目内容',
  `options_json` json NOT NULL COMMENT '选项与分值',
  `scoring_rule` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计分说明',
  `weight` int NOT NULL DEFAULT 0 COMMENT '权重',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_subhealth_type_code`(`type_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '亚健康评估量表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of subhealth_assessment_scale
-- ----------------------------
INSERT INTO `subhealth_assessment_scale` VALUES (1, 1, '亚健康评估量表：生理指标', 'PH1', 'BMI指数', '[{\"range\": \"18.5-24\", \"score\": 0}, {\"range\": \"24-28 或 =18.5\", \"score\": 10}, {\"range\": \">=28 或 <=18\", \"score\": 20}]', '自动读取近30天最新身高体重计算', 40, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (2, 1, '亚健康评估量表：生理指标', 'PH2', '血压（收缩压）', '[{\"range\": \"90-120\", \"score\": 0}, {\"range\": \"120-139 或 80-89\", \"score\": 10}, {\"range\": \">=140 或 <=90\", \"score\": 20}]', '自动读取近30天最新血压', 40, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (3, 1, '亚健康评估量表：生理指标', 'PH3', '空腹血糖', '[{\"range\": \"3.9-6.1\", \"score\": 0}, {\"range\": \"6.1-7.0\", \"score\": 15}, {\"range\": \">=7.0 或 <=3.9\", \"score\": 25}]', '自动读取近30天最新空腹血糖', 40, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (4, 1, '亚健康评估量表：生理指标', 'PH4', '血脂（总胆固醇）', '[{\"range\": \"<5.2\", \"score\": 0}, {\"range\": \"5.2-6.2\", \"score\": 10}, {\"range\": \">6.2\", \"score\": 20}]', '自动读取近30天最新总胆固醇', 40, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (5, 2, '亚健康评估量表：心理状态', 'P1', '您是否感到情绪低落或沮丧？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', '心理维度原始分0-20，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (6, 2, '亚健康评估量表：心理状态', 'P2', '您是否感到焦虑或紧张？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', '心理维度原始分0-20，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (7, 2, '亚健康评估量表：心理状态', 'P3', '您是否对日常活动失去兴趣？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', '心理维度原始分0-20，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (8, 2, '亚健康评估量表：心理状态', 'P4', '您是否感到疲劳或精力不足？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', '心理维度原始分0-20，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (9, 2, '亚健康评估量表：心理状态', 'P5', '您是否难以集中注意力？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 1, \"option\": \"很少\"}, {\"score\": 2, \"option\": \"有时\"}, {\"score\": 3, \"option\": \"经常\"}, {\"score\": 4, \"option\": \"总是\"}]', '心理维度原始分0-20，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (10, 3, '亚健康评估量表：生活习惯', 'L1', '您平均每晚睡眠时长？', '[{\"score\": 0, \"option\": \">=7小时\"}, {\"score\": 10, \"option\": \"6-7小时\"}, {\"score\": 20, \"option\": \"<6小时\"}]', '生活习惯维度原始分0-100，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (11, 3, '亚健康评估量表：生活习惯', 'L2', '您每周运动频率？', '[{\"score\": 0, \"option\": \">=3次/周\"}, {\"score\": 10, \"option\": \"1-2次/周\"}, {\"score\": 20, \"option\": \"几乎不运动\"}]', '生活习惯维度原始分0-100，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (12, 3, '亚健康评估量表：生活习惯', 'L3', '您的饮食结构？', '[{\"score\": 0, \"option\": \"荤素均衡\"}, {\"score\": 10, \"option\": \"偏荤或偏素\"}, {\"score\": 20, \"option\": \"常吃外卖/快餐\"}]', '生活习惯维度原始分0-100，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (13, 3, '亚健康评估量表：生活习惯', 'L4', '您是否吸烟或饮酒？', '[{\"score\": 0, \"option\": \"从不\"}, {\"score\": 10, \"option\": \"偶尔\"}, {\"score\": 20, \"option\": \"经常\"}]', '生活习惯维度原始分0-100，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `subhealth_assessment_scale` VALUES (14, 3, '亚健康评估量表：生活习惯', 'L5', '您每天的久坐时长（含工作）？', '[{\"score\": 0, \"option\": \"<4小时\"}, {\"score\": 10, \"option\": \"4-8小时\"}, {\"score\": 20, \"option\": \">8小时\"}]', '生活习惯维度原始分0-100，换算后乘0.3', 30, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `target_scope` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '推送范围(JSON格式或\"全部\")',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-草稿,1-已发布,2-已下架',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `admin_id` int NOT NULL COMMENT '管理员ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_admin_id`(`admin_id` ASC) USING BTREE,
  CONSTRAINT `fk_system_notice_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_notice
-- ----------------------------
INSERT INTO `system_notice` VALUES (1, '欢迎使用健康管理平台', '完成体质评估后，系统将为您推荐适合的运动视频与养生食谱。坚持打卡可获得阶段性健康反馈。', '全部', 1, '2026-05-15 14:35:38', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `system_notice` VALUES (2, '五月运动挑战开启', '本月完成至少 12 次运动打卡的用户，可在社交广场分享成果。建议每周运动 3-5 次，每次 20-40 分钟。', '全部', 1, '2026-05-15 14:35:38', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `system_notice` VALUES (3, '夏季养生提醒', '气温升高请注意补水与防晒。湿热体质用户可适当增加清热利湿类食谱，避免高糖冷饮。', '全部', 1, '2026-05-15 14:35:38', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');

-- ----------------------------
-- Table structure for tcm_constitution_assessment_scale
-- ----------------------------
DROP TABLE IF EXISTS `tcm_constitution_assessment_scale`;
CREATE TABLE `tcm_constitution_assessment_scale`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `type_code` tinyint NOT NULL COMMENT '类型编码:4-12',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '体质类型',
  `question_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题号',
  `question_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目内容',
  `options_json` json NOT NULL COMMENT '选项与分值',
  `reverse_score` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否反向计分',
  `scoring_rule` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计分说明',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tcm_type_code`(`type_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '中医体质评估量表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tcm_constitution_assessment_scale
-- ----------------------------
INSERT INTO `tcm_constitution_assessment_scale` VALUES (1, 4, '中医体质评估量表：平和质', 'A1', '您精力充沛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (2, 4, '中医体质评估量表：平和质', 'A2', '您容易疲劳吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (3, 4, '中医体质评估量表：平和质', 'A3', '您说话声音低弱无力吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (4, 4, '中医体质评估量表：平和质', 'A4', '您感到闷闷不乐、情绪低沉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (5, 4, '中医体质评估量表：平和质', 'A5', '您比一般人耐受不了寒冷吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (6, 4, '中医体质评估量表：平和质', 'A6', '您能适应外界自然和社会环境的变化吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (7, 4, '中医体质评估量表：平和质', 'A7', '您容易失眠吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (8, 4, '中医体质评估量表：平和质', 'A8', '您容易忘事吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 1, '转化分=(原始分-题目数)/(题目数*4)*100', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (9, 5, '中医体质评估量表：气虚质', 'B1', '您容易疲乏吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (10, 5, '中医体质评估量表：气虚质', 'B2', '您容易气短（呼吸短促）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (11, 5, '中医体质评估量表：气虚质', 'B3', '您容易心慌吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (12, 5, '中医体质评估量表：气虚质', 'B4', '您容易头晕或站起时晕眩吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (13, 5, '中医体质评估量表：气虚质', 'B5', '您比别人容易感冒吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (14, 5, '中医体质评估量表：气虚质', 'B6', '您喜欢安静、懒得说话吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (15, 5, '中医体质评估量表：气虚质', 'B7', '您说话声音低弱无力吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (16, 6, '中医体质评估量表：阳虚质', 'C1', '您手脚发凉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (17, 6, '中医体质评估量表：阳虚质', 'C2', '您胃脘部、背部或腰膝部怕冷吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (18, 6, '中医体质评估量表：阳虚质', 'C3', '您感到怕冷、衣服比别人穿得多吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (19, 6, '中医体质评估量表：阳虚质', 'C4', '您比一般人耐受不了寒冷？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (20, 6, '中医体质评估量表：阳虚质', 'C5', '您比别人容易患感冒吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (21, 6, '中医体质评估量表：阳虚质', 'C6', '您吃（喝）凉的东西会感到不舒服吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (22, 6, '中医体质评估量表：阳虚质', 'C7', '您受凉或吃凉的东西后容易腹泻吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (23, 7, '中医体质评估量表：阴虚质', 'D1', '您感到手脚心发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (24, 7, '中医体质评估量表：阴虚质', 'D2', '您感觉身体、脸上发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (25, 7, '中医体质评估量表：阴虚质', 'D3', '您皮肤或口唇干吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (26, 7, '中医体质评估量表：阴虚质', 'D4', '您口唇的颜色比一般人红吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (27, 7, '中医体质评估量表：阴虚质', 'D5', '您容易便秘或大便干燥吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (28, 7, '中医体质评估量表：阴虚质', 'D6', '您面部两颧潮红或偏红吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (29, 7, '中医体质评估量表：阴虚质', 'D7', '您感到眼睛干涩吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (30, 8, '中医体质评估量表：痰湿质', 'E1', '您感到胸闷或腹部胀满吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (31, 8, '中医体质评估量表：痰湿质', 'E2', '您感到身体沉重不轻松吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (32, 8, '中医体质评估量表：痰湿质', 'E3', '您腹部肥满松软吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (33, 8, '中医体质评估量表：痰湿质', 'E4', '您有额部油脂分泌多的现象吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (34, 8, '中医体质评估量表：痰湿质', 'E5', '您上眼睑比别人肿吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (35, 8, '中医体质评估量表：痰湿质', 'E6', '您嘴里有黏黏的感觉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (36, 8, '中医体质评估量表：痰湿质', 'E7', '您平时痰多吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (37, 9, '中医体质评估量表：湿热质', 'F1', '您面部或鼻部有油腻感吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (38, 9, '中医体质评估量表：湿热质', 'F2', '您容易生痤疮或疮疖吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (39, 9, '中医体质评估量表：湿热质', 'F3', '您感到口苦或嘴里有异味吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (40, 9, '中医体质评估量表：湿热质', 'F4', '您大便黏滞不爽、有解不尽的感觉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (41, 9, '中医体质评估量表：湿热质', 'F5', '您小便时尿道有发热感、尿色浓吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (42, 9, '中医体质评估量表：湿热质', 'F6', '您带下色黄（女性）或阴囊潮湿（男性）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (43, 9, '中医体质评估量表：湿热质', 'F7', '您身重困倦、午后发热吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (44, 10, '中医体质评估量表：血瘀质', 'G1', '您的皮肤在不知不觉中会出现青紫瘀斑吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (45, 10, '中医体质评估量表：血瘀质', 'G2', '您两颧部有细微红丝吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (46, 10, '中医体质评估量表：血瘀质', 'G3', '您身体上有哪里疼痛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (47, 10, '中医体质评估量表：血瘀质', 'G4', '您面色晦暗或容易出现褐斑吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (48, 10, '中医体质评估量表：血瘀质', 'G5', '您容易有黑眼圈吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (49, 10, '中医体质评估量表：血瘀质', 'G6', '您容易忘事吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (50, 10, '中医体质评估量表：血瘀质', 'G7', '您口唇颜色偏暗吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (51, 11, '中医体质评估量表：气郁质', 'H1', '您感到闷闷不乐、情绪低沉吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (52, 11, '中医体质评估量表：气郁质', 'H2', '您容易精神紧张、焦虑不安吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (53, 11, '中医体质评估量表：气郁质', 'H3', '您多愁善感、感情脆弱吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (54, 11, '中医体质评估量表：气郁质', 'H4', '您容易感到害怕或受到惊吓吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (55, 11, '中医体质评估量表：气郁质', 'H5', '您胁肋部或乳房胀痛吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (56, 11, '中医体质评估量表：气郁质', 'H6', '您无缘无故叹气吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (57, 11, '中医体质评估量表：气郁质', 'H7', '您咽喉部有异物感吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (58, 12, '中医体质评估量表：特禀质', 'I1', '您没有感冒时也会打喷嚏吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (59, 12, '中医体质评估量表：特禀质', 'I2', '您没有感冒时也会鼻塞、流鼻涕吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (60, 12, '中医体质评估量表：特禀质', 'I3', '您有因季节变化、温度变化或异味而咳喘的现象吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (61, 12, '中医体质评估量表：特禀质', 'I4', '您容易过敏（药物、食物、花粉等）吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (62, 12, '中医体质评估量表：特禀质', 'I5', '您的皮肤容易起荨麻疹吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (63, 12, '中医体质评估量表：特禀质', 'I6', '您的皮肤因过敏出现过紫癜吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `tcm_constitution_assessment_scale` VALUES (64, 12, '中医体质评估量表：特禀质', 'I7', '您的皮肤一抓就红、并出现抓痕吗？', '[{\"score\": 1, \"option\": \"没有\"}, {\"score\": 2, \"option\": \"很少\"}, {\"score\": 3, \"option\": \"有时\"}, {\"score\": 4, \"option\": \"经常\"}, {\"score\": 5, \"option\": \"总是\"}]', 0, '转化分>=40判定，30-39为倾向', 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');

-- ----------------------------
-- Table structure for tcm_constitution_question
-- ----------------------------
DROP TABLE IF EXISTS `tcm_constitution_question`;
CREATE TABLE `tcm_constitution_question`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `constitution_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '体质类型（中文）：平和质、气虚质、阳虚质、阴虚质、痰湿质、湿热质、血瘀质、气郁质、特禀质',
  `question_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目内容',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '题目在该体质下的顺序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_constitution_type`(`constitution_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '中医体质题目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tcm_constitution_question
-- ----------------------------
INSERT INTO `tcm_constitution_question` VALUES (65, '平和质', '您精力充沛吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (66, '平和质', '您容易疲乏吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (67, '平和质', '您说话声音低弱无力吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (68, '平和质', '您感到闷闷不乐、情绪低沉吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (69, '平和质', '您比一般人耐受不了寒冷吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (70, '平和质', '您能适应外界自然和社会环境的变化吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (71, '平和质', '您容易失眠吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (72, '平和质', '您容易忘事吗？', 8, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (73, '气虚质', '您容易疲乏吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (74, '气虚质', '您容易气短（呼吸短促、接不上气）吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (75, '气虚质', '您容易心慌吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (76, '气虚质', '您容易头晕或站起时晕眩吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (77, '气虚质', '您比别人容易患感冒吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (78, '气虚质', '您喜欢安静、懒得说话吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (79, '气虚质', '您说话声音低弱无力吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (80, '阳虚质', '您手脚发凉吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (81, '阳虚质', '您胃脘部、背部或腰膝部怕冷吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (82, '阳虚质', '您感到怕冷、衣服比别人穿得多吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (83, '阳虚质', '您比一般人耐受不了寒冷吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (84, '阳虚质', '您比别人容易患感冒吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (85, '阳虚质', '您吃（喝）凉的东西会感到不舒服或者怕吃凉的吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (86, '阳虚质', '您受凉或吃凉的后，容易拉肚子吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (87, '阴虚质', '您感到手脚心发热吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (88, '阴虚质', '您感觉身体、脸上发热吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (89, '阴虚质', '您皮肤或口唇干吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (90, '阴虚质', '您口唇的颜色比一般人红吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (91, '阴虚质', '您容易便秘或大便干燥吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (92, '阴虚质', '您面部两颧潮红或偏红吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (93, '阴虚质', '您感到眼睛干涩吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (94, '痰湿质', '您感到胸闷或腹部胀满吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (95, '痰湿质', '您感觉身体沉重不轻松或不爽快吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (96, '痰湿质', '您腹部肥满松软吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (97, '痰湿质', '您有额部油脂分泌多的现象吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (98, '痰湿质', '您上眼睑比别人肿（上眼睑有轻微隆起）吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (99, '痰湿质', '您嘴里有黏黏的感觉吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (100, '痰湿质', '您平时痰多，特别是咽喉部总感到有痰堵着吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (101, '湿热质', '您面部或鼻部有油腻感或者油亮发光吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (102, '湿热质', '您容易生痤疮或疮疖吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (103, '湿热质', '您感到口苦或嘴里有异味吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (104, '湿热质', '您大便黏滞不爽、有解不尽的感觉吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (105, '湿热质', '您小便时尿道有发热感、尿色浓（深）吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (106, '湿热质', '您带下色黄（白带颜色发黄）吗？（限女性回答）', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (107, '湿热质', '您的阴囊部位潮湿吗？（限男性回答）', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (108, '血瘀质', '您的皮肤在不知不觉中会出现青紫瘀斑（皮下出血）吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (109, '血瘀质', '您两颧部有细微红丝吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (110, '血瘀质', '您身体上有哪里疼痛吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (111, '血瘀质', '您面色晦暗或容易出现褐斑吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (112, '血瘀质', '您容易有黑眼圈吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (113, '血瘀质', '您容易忘事（健忘）吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (114, '血瘀质', '您口唇颜色偏暗吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (115, '气郁质', '您感到闷闷不乐、情绪低沉吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (116, '气郁质', '您容易精神紧张、焦虑不安吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (117, '气郁质', '您多愁善感、感情脆弱吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (118, '气郁质', '您容易感到害怕或受到惊吓吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (119, '气郁质', '您胁肋部或乳房胀痛吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (120, '气郁质', '您无缘无故叹气吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (121, '气郁质', '您咽喉部有异物感，且吐之不出、咽之不下吗？', 7, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (122, '特禀质', '您没有感冒时也会打喷嚏吗？', 1, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (123, '特禀质', '您没有感冒时也会鼻塞、流鼻涕吗？', 2, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (124, '特禀质', '您有因季节变化、温度变化或异味等原因而咳喘的现象吗？', 3, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (125, '特禀质', '您容易过敏（对药物、食物、气味、花粉等）吗？', 4, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (126, '特禀质', '您的皮肤容易起荨麻疹吗？', 5, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (127, '特禀质', '您的皮肤因过敏出现过紫癜（紫红色瘀点、瘀斑）吗？', 6, 1, '2026-04-26 16:07:48', NULL);
INSERT INTO `tcm_constitution_question` VALUES (128, '特禀质', '您的皮肤一抓就红，并出现抓痕吗？', 7, 1, '2026-04-26 16:07:48', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(BCrypt加密)',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  `gender` tinyint(1) NULL DEFAULT NULL COMMENT '性别:0-女,1-男,2-未知',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '账号状态:0-正常,1-禁用',
  `social_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '社交状态:0-正常,1-禁言',
  `create_time` datetime NOT NULL COMMENT '注册时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'demo_user', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13800138001', 'demo1@health.com', 'https://randomuser.me/api/portraits/men/11.jpg', 27, 1, 0, 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user` VALUES (2, 'fit_anna', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13800138002', 'anna@health.com', 'https://randomuser.me/api/portraits/women/12.jpg', 25, 0, 0, 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user` VALUES (3, 'wellness_bob', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13800138003', 'bob@health.com', 'https://randomuser.me/api/portraits/men/13.jpg', 30, 1, 0, 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user` VALUES (4, 'foodie_cici', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13800138004', 'cici@health.com', 'https://randomuser.me/api/portraits/women/14.jpg', 24, 0, 0, 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user` VALUES (5, 'runner_dan', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13800138005', 'dan@health.com', 'https://randomuser.me/api/portraits/men/15.jpg', 29, 1, 0, 0, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user` VALUES (6, 'rql', '$2a$10$IgnnTJO4CYxZzEmO88ReseGTLt1IyDJUYDlyzuPFEevxseHDum5im', '16670000000', 'rql@demo.health', 'https://randomuser.me/api/portraits/men/88.jpg', 28, 1, 0, 0, '2026-05-15 18:11:03', '2026-05-19 18:36:11');
INSERT INTO `user` VALUES (7, '李娜', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000007', '李娜@demo.health', NULL, 32, 1, 0, 0, '2026-04-03 10:00:00', '2026-04-03 10:00:00');
INSERT INTO `user` VALUES (8, '王芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000008', '王芳@demo.health', NULL, 33, 2, 0, 0, '2026-04-04 10:00:00', '2026-04-04 10:00:00');
INSERT INTO `user` VALUES (9, '刘洋', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000009', '刘洋@demo.health', NULL, 34, 0, 0, 0, '2026-04-05 10:00:00', '2026-04-05 10:00:00');
INSERT INTO `user` VALUES (10, '陈静', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000010', '陈静@demo.health', NULL, 35, 1, 0, 0, '2026-04-06 10:00:00', '2026-04-06 10:00:00');
INSERT INTO `user` VALUES (11, '杨磊', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000011', '杨磊@demo.health', NULL, 36, 2, 0, 0, '2026-04-07 10:00:00', '2026-04-07 10:00:00');
INSERT INTO `user` VALUES (12, '赵敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000012', '赵敏@demo.health', NULL, 37, 0, 0, 0, '2026-04-08 10:00:00', '2026-04-08 10:00:00');
INSERT INTO `user` VALUES (13, '黄磊', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000013', '黄磊@demo.health', NULL, 38, 1, 0, 0, '2026-04-09 10:00:00', '2026-04-09 10:00:00');
INSERT INTO `user` VALUES (14, '周杰', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000014', '周杰@demo.health', NULL, 39, 2, 0, 0, '2026-04-10 10:00:00', '2026-04-10 10:00:00');
INSERT INTO `user` VALUES (15, '吴婷', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000015', '吴婷@demo.health', NULL, 25, 0, 0, 0, '2026-04-11 10:00:00', '2026-04-11 10:00:00');
INSERT INTO `user` VALUES (16, '徐鹏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000016', '徐鹏@demo.health', NULL, 26, 1, 0, 0, '2026-04-12 10:00:00', '2026-04-12 10:00:00');
INSERT INTO `user` VALUES (17, '孙丽', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000017', '孙丽@demo.health', NULL, 27, 2, 0, 0, '2026-04-13 10:00:00', '2026-04-13 10:00:00');
INSERT INTO `user` VALUES (18, '马超', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000018', '马超@demo.health', NULL, 28, 0, 0, 0, '2026-04-14 10:00:00', '2026-04-14 10:00:00');
INSERT INTO `user` VALUES (19, '朱军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000019', '朱军@demo.health', NULL, 29, 1, 0, 0, '2026-04-15 10:00:00', '2026-04-15 10:00:00');
INSERT INTO `user` VALUES (20, '胡雪', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000020', '胡雪@demo.health', NULL, 30, 2, 0, 0, '2026-04-16 10:00:00', '2026-04-16 10:00:00');
INSERT INTO `user` VALUES (21, '林峰', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000021', '林峰@demo.health', NULL, 31, 0, 0, 0, '2026-04-17 10:00:00', '2026-04-17 10:00:00');
INSERT INTO `user` VALUES (22, '郭燕', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000022', '郭燕@demo.health', NULL, 32, 1, 0, 0, '2026-04-18 10:00:00', '2026-04-18 10:00:00');
INSERT INTO `user` VALUES (23, '何斌', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000023', '何斌@demo.health', NULL, 33, 2, 0, 0, '2026-04-19 10:00:00', '2026-04-19 10:00:00');
INSERT INTO `user` VALUES (24, '高霞', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000024', '高霞@demo.health', NULL, 34, 0, 0, 0, '2026-04-20 10:00:00', '2026-04-20 10:00:00');
INSERT INTO `user` VALUES (25, '罗刚', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000025', '罗刚@demo.health', NULL, 35, 1, 0, 0, '2026-04-21 10:00:00', '2026-04-21 10:00:00');
INSERT INTO `user` VALUES (26, '郑洁', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000026', '郑洁@demo.health', NULL, 36, 2, 0, 0, '2026-04-22 10:00:00', '2026-04-22 10:00:00');
INSERT INTO `user` VALUES (27, '梁辉', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000027', '梁辉@demo.health', NULL, 37, 0, 0, 0, '2026-04-23 10:00:00', '2026-04-23 10:00:00');
INSERT INTO `user` VALUES (28, '谢芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000028', '谢芳@demo.health', NULL, 38, 1, 0, 0, '2026-04-24 10:00:00', '2026-04-24 10:00:00');
INSERT INTO `user` VALUES (29, '宋宇', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000029', '宋宇@demo.health', NULL, 39, 2, 0, 0, '2026-04-25 10:00:00', '2026-04-25 10:00:00');
INSERT INTO `user` VALUES (30, '唐琳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000030', '唐琳@demo.health', NULL, 25, 0, 0, 0, '2026-04-26 10:00:00', '2026-04-26 10:00:00');
INSERT INTO `user` VALUES (31, '韩梅', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000031', '韩梅@demo.health', NULL, 26, 1, 0, 0, '2026-04-27 10:00:00', '2026-04-27 10:00:00');
INSERT INTO `user` VALUES (32, '冯涛', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000032', '冯涛@demo.health', NULL, 27, 2, 0, 0, '2026-04-28 10:00:00', '2026-04-28 10:00:00');
INSERT INTO `user` VALUES (33, '于娜', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000033', '于娜@demo.health', NULL, 28, 0, 0, 0, '2026-04-29 10:00:00', '2026-04-29 10:00:00');
INSERT INTO `user` VALUES (34, '董强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000034', '董强@demo.health', NULL, 29, 1, 0, 0, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user` VALUES (35, '薛薇', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000035', '薛薇@demo.health', NULL, 30, 2, 0, 0, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user` VALUES (36, '程浩', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000036', '程浩@demo.health', NULL, 31, 0, 0, 0, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user` VALUES (37, '曹颖', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000037', '曹颖@demo.health', NULL, 32, 1, 0, 0, '2026-05-04 10:00:00', '2026-05-04 10:00:00');
INSERT INTO `user` VALUES (38, '袁鹏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000038', '袁鹏@demo.health', NULL, 33, 2, 0, 0, '2026-05-05 10:00:00', '2026-05-05 10:00:00');
INSERT INTO `user` VALUES (39, '邓琳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000039', '邓琳@demo.health', NULL, 34, 0, 0, 0, '2026-05-06 10:00:00', '2026-05-06 10:00:00');
INSERT INTO `user` VALUES (40, '许军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000040', '许军@demo.health', NULL, 35, 1, 0, 0, '2026-05-07 10:00:00', '2026-05-07 10:00:00');
INSERT INTO `user` VALUES (41, '傅敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000041', '傅敏@demo.health', NULL, 36, 2, 0, 0, '2026-05-08 10:00:00', '2026-05-08 10:00:00');
INSERT INTO `user` VALUES (42, '沈强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000042', '沈强@demo.health', NULL, 37, 0, 0, 0, '2026-05-09 10:00:00', '2026-05-09 10:00:00');
INSERT INTO `user` VALUES (43, '曾丽', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000043', '曾丽@demo.health', NULL, 38, 1, 0, 0, '2026-05-10 10:00:00', '2026-05-10 10:00:00');
INSERT INTO `user` VALUES (44, '彭飞', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000044', '彭飞@demo.health', NULL, 39, 2, 0, 0, '2026-05-11 10:00:00', '2026-05-11 10:00:00');
INSERT INTO `user` VALUES (45, '吕娟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000045', '吕娟@demo.health', NULL, 25, 0, 0, 0, '2026-05-12 10:00:00', '2026-05-12 10:00:00');
INSERT INTO `user` VALUES (46, '苏伟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000046', '苏伟@demo.health', NULL, 26, 1, 0, 0, '2026-05-13 10:00:00', '2026-05-13 10:00:00');
INSERT INTO `user` VALUES (47, '卢艳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000047', '卢艳@demo.health', NULL, 27, 2, 0, 0, '2026-05-14 10:00:00', '2026-05-14 10:00:00');
INSERT INTO `user` VALUES (48, '蒋浩', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000048', '蒋浩@demo.health', NULL, 28, 0, 0, 0, '2026-05-15 10:00:00', '2026-05-15 10:00:00');
INSERT INTO `user` VALUES (49, '蔡芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000049', '蔡芳@demo.health', NULL, 29, 1, 0, 0, '2026-05-16 10:00:00', '2026-05-16 10:00:00');
INSERT INTO `user` VALUES (50, '贾斌', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000050', '贾斌@demo.health', NULL, 30, 2, 0, 0, '2026-05-17 10:00:00', '2026-05-17 10:00:00');
INSERT INTO `user` VALUES (51, '丁敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000051', '丁敏@demo.health', NULL, 31, 0, 0, 0, '2026-05-18 10:00:00', '2026-05-18 10:00:00');
INSERT INTO `user` VALUES (52, '魏强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000052', '魏强@demo.health', NULL, 32, 1, 0, 0, '2026-05-19 10:00:00', '2026-05-19 10:00:00');
INSERT INTO `user` VALUES (53, '薛娜', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000053', '薛娜@demo.health', NULL, 33, 2, 0, 0, '2026-05-20 10:00:00', '2026-05-20 10:00:00');
INSERT INTO `user` VALUES (54, '叶军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000054', '叶军@demo.health', NULL, 34, 0, 0, 0, '2026-05-21 10:00:00', '2026-05-21 10:00:00');
INSERT INTO `user` VALUES (55, '阎丽', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000055', '阎丽@demo.health', NULL, 35, 1, 0, 0, '2026-05-22 10:00:00', '2026-05-22 10:00:00');
INSERT INTO `user` VALUES (56, '石磊', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000056', '石磊@demo.health', NULL, 36, 2, 0, 0, '2026-04-02 10:00:00', '2026-04-02 10:00:00');
INSERT INTO `user` VALUES (57, '顾敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000057', '顾敏@demo.health', NULL, 37, 0, 0, 0, '2026-04-03 10:00:00', '2026-04-03 10:00:00');
INSERT INTO `user` VALUES (58, '谭静', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000058', '谭静@demo.health', NULL, 38, 1, 0, 0, '2026-04-04 10:00:00', '2026-04-04 10:00:00');
INSERT INTO `user` VALUES (59, '易洋', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000059', '易洋@demo.health', NULL, 39, 2, 0, 0, '2026-04-05 10:00:00', '2026-04-05 10:00:00');
INSERT INTO `user` VALUES (60, '常军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000060', '常军@demo.health', NULL, 25, 0, 0, 0, '2026-04-06 10:00:00', '2026-04-06 10:00:00');
INSERT INTO `user` VALUES (61, '康莉', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000061', '康莉@demo.health', NULL, 26, 1, 0, 0, '2026-04-07 10:00:00', '2026-04-07 10:00:00');
INSERT INTO `user` VALUES (62, '温杰', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000062', '温杰@demo.health', NULL, 27, 2, 0, 0, '2026-04-08 10:00:00', '2026-04-08 10:00:00');
INSERT INTO `user` VALUES (63, '白燕', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000063', '白燕@demo.health', NULL, 28, 0, 0, 0, '2026-04-09 10:00:00', '2026-04-09 10:00:00');
INSERT INTO `user` VALUES (64, '孔涛', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000064', '孔涛@demo.health', NULL, 29, 1, 0, 0, '2026-04-10 10:00:00', '2026-04-10 10:00:00');
INSERT INTO `user` VALUES (65, '龙霞', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000065', '龙霞@demo.health', NULL, 30, 2, 0, 0, '2026-04-11 10:00:00', '2026-04-11 10:00:00');
INSERT INTO `user` VALUES (66, '田芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000066', '田芳@demo.health', NULL, 31, 0, 0, 0, '2026-04-12 10:00:00', '2026-04-12 10:00:00');
INSERT INTO `user` VALUES (67, '夏斌', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000067', '夏斌@demo.health', NULL, 32, 1, 0, 0, '2026-04-13 10:00:00', '2026-04-13 10:00:00');
INSERT INTO `user` VALUES (68, '毛琳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000068', '毛琳@demo.health', NULL, 33, 2, 0, 0, '2026-04-14 10:00:00', '2026-04-14 10:00:00');
INSERT INTO `user` VALUES (69, '向强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000069', '向强@demo.health', NULL, 34, 0, 0, 0, '2026-04-15 10:00:00', '2026-04-15 10:00:00');
INSERT INTO `user` VALUES (70, '尤娟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000070', '尤娟@demo.health', NULL, 35, 1, 0, 0, '2026-04-16 10:00:00', '2026-04-16 10:00:00');
INSERT INTO `user` VALUES (71, '贺伟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000071', '贺伟@demo.health', NULL, 36, 2, 0, 0, '2026-04-17 10:00:00', '2026-04-17 10:00:00');
INSERT INTO `user` VALUES (72, '汤蕾', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000072', '汤蕾@demo.health', NULL, 37, 0, 0, 0, '2026-04-18 10:00:00', '2026-04-18 10:00:00');
INSERT INTO `user` VALUES (73, '寇军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000073', '寇军@demo.health', NULL, 38, 1, 0, 0, '2026-04-19 10:00:00', '2026-04-19 10:00:00');
INSERT INTO `user` VALUES (74, '黎娜', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000074', '黎娜@demo.health', NULL, 39, 2, 0, 0, '2026-04-20 10:00:00', '2026-04-20 10:00:00');
INSERT INTO `user` VALUES (75, '邱刚', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000075', '邱刚@demo.health', NULL, 25, 0, 0, 0, '2026-04-21 10:00:00', '2026-04-21 10:00:00');
INSERT INTO `user` VALUES (76, '梅洁', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000076', '梅洁@demo.health', NULL, 26, 1, 0, 0, '2026-04-22 10:00:00', '2026-04-22 10:00:00');
INSERT INTO `user` VALUES (77, '殷辉', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000077', '殷辉@demo.health', NULL, 27, 2, 0, 0, '2026-04-23 10:00:00', '2026-04-23 10:00:00');
INSERT INTO `user` VALUES (78, '樊芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000078', '樊芳@demo.health', NULL, 28, 0, 0, 0, '2026-04-24 10:00:00', '2026-04-24 10:00:00');
INSERT INTO `user` VALUES (79, '段宇', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000079', '段宇@demo.health', NULL, 29, 1, 0, 0, '2026-04-25 10:00:00', '2026-04-25 10:00:00');
INSERT INTO `user` VALUES (80, '雷琳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000080', '雷琳@demo.health', NULL, 30, 2, 0, 0, '2026-04-26 10:00:00', '2026-04-26 10:00:00');
INSERT INTO `user` VALUES (81, '侯涛', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000081', '侯涛@demo.health', NULL, 31, 0, 0, 0, '2026-04-27 10:00:00', '2026-04-27 10:00:00');
INSERT INTO `user` VALUES (82, '邵娜', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000082', '邵娜@demo.health', NULL, 32, 1, 0, 0, '2026-04-28 10:00:00', '2026-04-28 10:00:00');
INSERT INTO `user` VALUES (83, '史强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000083', '史强@demo.health', NULL, 33, 2, 0, 0, '2026-04-29 10:00:00', '2026-04-29 10:00:00');
INSERT INTO `user` VALUES (84, '钱莉', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000084', '钱莉@demo.health', NULL, 34, 0, 0, 0, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user` VALUES (85, '方伟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000085', '方伟@demo.health', NULL, 35, 1, 0, 0, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user` VALUES (86, '倪艳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000086', '倪艳@demo.health', NULL, 36, 2, 0, 0, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user` VALUES (87, '严浩', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000087', '严浩@demo.health', NULL, 37, 0, 0, 0, '2026-05-04 10:00:00', '2026-05-04 10:00:00');
INSERT INTO `user` VALUES (88, '毕芳', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000088', '毕芳@demo.health', NULL, 38, 1, 0, 0, '2026-05-05 10:00:00', '2026-05-05 10:00:00');
INSERT INTO `user` VALUES (89, '安斌', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000089', '安斌@demo.health', NULL, 39, 2, 0, 0, '2026-05-06 10:00:00', '2026-05-06 10:00:00');
INSERT INTO `user` VALUES (90, '齐敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000090', '齐敏@demo.health', NULL, 25, 0, 0, 0, '2026-05-07 10:00:00', '2026-05-07 10:00:00');
INSERT INTO `user` VALUES (91, '郝强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000091', '郝强@demo.health', NULL, 26, 1, 0, 0, '2026-05-08 10:00:00', '2026-05-08 10:00:00');
INSERT INTO `user` VALUES (92, '伍丽', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000092', '伍丽@demo.health', NULL, 27, 2, 0, 0, '2026-05-09 10:00:00', '2026-05-09 10:00:00');
INSERT INTO `user` VALUES (93, '季军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000093', '季军@demo.health', NULL, 28, 0, 0, 0, '2026-05-10 10:00:00', '2026-05-10 10:00:00');
INSERT INTO `user` VALUES (94, '聂洁', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000094', '聂洁@demo.health', NULL, 29, 1, 0, 0, '2026-05-11 10:00:00', '2026-05-11 10:00:00');
INSERT INTO `user` VALUES (95, '汪伟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000095', '汪伟@demo.health', NULL, 30, 2, 0, 0, '2026-05-12 10:00:00', '2026-05-12 10:00:00');
INSERT INTO `user` VALUES (96, '凌敏', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000096', '凌敏@demo.health', NULL, 31, 0, 0, 0, '2026-05-13 10:00:00', '2026-05-13 10:00:00');
INSERT INTO `user` VALUES (97, '刁强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000097', '刁强@demo.health', NULL, 32, 1, 0, 0, '2026-05-14 10:00:00', '2026-05-14 10:00:00');
INSERT INTO `user` VALUES (98, '霍丽', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000098', '霍丽@demo.health', NULL, 33, 2, 0, 0, '2026-05-15 10:00:00', '2026-05-15 10:00:00');
INSERT INTO `user` VALUES (99, '谷军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000099', '谷军@demo.health', NULL, 34, 0, 0, 0, '2026-05-16 10:00:00', '2026-05-16 10:00:00');
INSERT INTO `user` VALUES (101, '晏莉', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000101', '晏莉@demo.health', NULL, 36, 2, 0, 0, '2026-05-18 10:00:00', '2026-05-18 10:00:00');
INSERT INTO `user` VALUES (102, '纪强', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000102', '纪强@demo.health', NULL, 37, 0, 0, 0, '2026-05-19 10:00:00', '2026-05-19 10:00:00');
INSERT INTO `user` VALUES (103, '管伟', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000103', '管伟@demo.health', NULL, 38, 1, 0, 0, '2026-05-20 10:00:00', '2026-05-20 10:00:00');
INSERT INTO `user` VALUES (104, '祁静', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000104', '祁静@demo.health', NULL, 39, 2, 0, 0, '2026-05-21 10:00:00', '2026-05-21 10:00:00');
INSERT INTO `user` VALUES (105, '童军', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '13910000105', '童军@demo.health', NULL, 25, 0, 0, 0, '2026-05-22 10:00:00', '2026-05-22 10:00:00');
INSERT INTO `user` VALUES (106, 'll', '$2a$10$tAc97BgBQ8maKMPpcn13FO50WVyhGrHcwfxlusgetbx6ZNijPIJiG', '17260000000', 'qwe@qq', NULL, NULL, 0, 0, 0, '2026-05-19 10:35:19', '2026-05-19 10:35:19');

-- ----------------------------
-- Table structure for user_recipe_collection
-- ----------------------------
DROP TABLE IF EXISTS `user_recipe_collection`;
CREATE TABLE `user_recipe_collection`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `recipe_id` int NOT NULL COMMENT '食谱ID',
  `create_time` datetime NOT NULL COMMENT '收藏时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_recipe`(`user_id` ASC, `recipe_id` ASC) USING BTREE,
  INDEX `idx_recipe_id`(`recipe_id` ASC) USING BTREE,
  CONSTRAINT `fk_recipe_collection_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_recipe_collection_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 761 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '食谱收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_recipe_collection
-- ----------------------------
INSERT INTO `user_recipe_collection` VALUES (1, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (2, 1, 2, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (3, 2, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (4, 2, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (5, 2, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (6, 3, 2, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (7, 3, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (8, 3, 5, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (9, 4, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (10, 4, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (11, 4, 6, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (12, 1, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (13, 1, 7, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (14, 1, 11, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (15, 1, 31, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (16, 5, 8, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (17, 5, 23, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (18, 5, 28, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (19, 3, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (20, 3, 10, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (21, 2, 2, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (22, 2, 14, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (23, 4, 5, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (24, 4, 33, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_recipe_collection` VALUES (480, 56, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (481, 56, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (482, 56, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (483, 56, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (484, 56, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (485, 57, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (486, 57, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (487, 57, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (488, 57, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (489, 57, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (490, 58, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (491, 58, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (492, 58, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (493, 58, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (494, 58, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (495, 59, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (496, 59, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (497, 59, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (498, 59, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (499, 59, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (500, 60, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (501, 60, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (502, 60, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (503, 60, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (504, 60, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (505, 61, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (506, 61, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (507, 61, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (508, 61, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (509, 61, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (510, 62, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (511, 62, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (512, 62, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (513, 62, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (514, 62, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (515, 63, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (516, 63, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (517, 63, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (518, 63, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (519, 63, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (520, 64, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (521, 64, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (522, 64, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (523, 64, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (524, 64, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (525, 65, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (526, 65, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (527, 65, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (528, 65, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (529, 65, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (530, 66, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (531, 66, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (532, 66, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (533, 66, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (534, 66, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (535, 66, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (536, 66, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (537, 66, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (538, 67, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (539, 67, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (540, 67, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (541, 67, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (542, 67, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (543, 67, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (544, 67, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (545, 67, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (546, 68, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (547, 68, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (548, 68, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (549, 68, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (550, 68, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (551, 68, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (552, 68, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (553, 68, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (554, 69, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (555, 69, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (556, 69, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (557, 69, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (558, 69, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (559, 69, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (560, 69, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (561, 69, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (562, 70, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (563, 70, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (564, 70, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (565, 70, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (566, 70, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (567, 70, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (568, 70, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (569, 70, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (570, 71, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (571, 71, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (572, 71, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (573, 71, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (574, 71, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (575, 71, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (576, 71, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (577, 71, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (578, 72, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (579, 72, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (580, 72, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (581, 72, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (582, 72, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (583, 72, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (584, 72, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (585, 72, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (586, 73, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (587, 73, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (588, 73, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (589, 73, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (590, 73, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (591, 73, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (592, 73, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (593, 73, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (594, 74, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (595, 74, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (596, 74, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (597, 74, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (598, 74, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (599, 74, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (600, 74, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (601, 74, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (602, 75, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (603, 75, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (604, 75, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (605, 75, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (606, 75, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (607, 75, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (608, 75, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (609, 75, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_recipe_collection` VALUES (610, 76, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (611, 76, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (612, 76, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (613, 76, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (614, 76, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (615, 77, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (616, 77, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (617, 77, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (618, 77, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (619, 77, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (620, 78, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (621, 78, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (622, 78, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (623, 78, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (624, 78, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (625, 79, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (626, 79, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (627, 79, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (628, 79, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (629, 79, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (630, 80, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (631, 80, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (632, 80, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (633, 80, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (634, 80, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (635, 81, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (636, 81, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (637, 81, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (638, 81, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (639, 81, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (640, 82, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (641, 82, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (642, 82, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (643, 82, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (644, 82, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (645, 83, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (646, 83, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (647, 83, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (648, 83, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (649, 83, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (650, 84, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (651, 84, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (652, 84, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (653, 84, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (654, 84, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (655, 85, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (656, 85, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (657, 85, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (658, 85, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (659, 85, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (660, 86, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (661, 86, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (662, 86, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (663, 86, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (664, 86, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (665, 87, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (666, 87, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (667, 87, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (668, 87, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (669, 87, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (670, 88, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (671, 88, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (672, 88, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (673, 88, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (674, 88, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (675, 89, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (676, 89, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (677, 89, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (678, 89, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (679, 89, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (680, 90, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (681, 90, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (682, 90, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (683, 90, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (684, 90, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (685, 91, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (686, 91, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (687, 91, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (688, 91, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (689, 91, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (690, 92, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (691, 92, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (692, 92, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (693, 92, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (694, 92, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (695, 93, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (696, 93, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (697, 93, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (698, 93, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (699, 93, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (700, 94, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (701, 94, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (702, 94, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (703, 94, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (704, 94, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (705, 95, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (706, 95, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (707, 95, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (708, 95, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (709, 95, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (710, 96, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (711, 96, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (712, 96, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (713, 96, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (714, 96, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (715, 97, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (716, 97, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (717, 97, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (718, 97, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (719, 97, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (720, 98, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (721, 98, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (722, 98, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (723, 98, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (724, 98, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (725, 99, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (726, 99, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (727, 99, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (728, 99, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (729, 99, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (735, 101, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (736, 101, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (737, 101, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (738, 101, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (739, 101, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (740, 102, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (741, 102, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (742, 102, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (743, 102, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (744, 102, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (745, 103, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (746, 103, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (747, 103, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (748, 103, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (749, 103, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (750, 104, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (751, 104, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (752, 104, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (753, 104, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (754, 104, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (755, 105, 3, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (756, 105, 8, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (757, 105, 12, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (758, 105, 18, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (759, 105, 25, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_recipe_collection` VALUES (760, 6, 1, '2026-05-15 18:12:19', '2026-05-15 18:12:19');

-- ----------------------------
-- Table structure for user_video_collection
-- ----------------------------
DROP TABLE IF EXISTS `user_video_collection`;
CREATE TABLE `user_video_collection`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `video_id` int NOT NULL COMMENT '视频ID',
  `create_time` datetime NOT NULL COMMENT '收藏时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_video`(`user_id` ASC, `video_id` ASC) USING BTREE,
  INDEX `idx_video_id`(`video_id` ASC) USING BTREE,
  CONSTRAINT `fk_video_collection_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_video_collection_video` FOREIGN KEY (`video_id`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 764 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '视频收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_video_collection
-- ----------------------------
INSERT INTO `user_video_collection` VALUES (1, 1, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (2, 1, 2, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (3, 2, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (4, 2, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (5, 2, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (6, 3, 2, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (7, 3, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (8, 3, 5, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (9, 4, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (10, 4, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (11, 4, 6, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (12, 1, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (13, 1, 4, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (14, 1, 31, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (15, 1, 32, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (16, 5, 7, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (17, 5, 8, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (18, 5, 21, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (19, 3, 7, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (20, 3, 12, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (21, 2, 5, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (22, 2, 14, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (23, 4, 3, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (24, 4, 33, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `user_video_collection` VALUES (480, 56, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (481, 56, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (482, 56, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (483, 56, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (484, 56, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (485, 57, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (486, 57, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (487, 57, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (488, 57, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (489, 57, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (490, 58, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (491, 58, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (492, 58, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (493, 58, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (494, 58, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (495, 59, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (496, 59, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (497, 59, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (498, 59, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (499, 59, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (500, 60, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (501, 60, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (502, 60, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (503, 60, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (504, 60, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (505, 61, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (506, 61, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (507, 61, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (508, 61, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (509, 61, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (510, 62, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (511, 62, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (512, 62, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (513, 62, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (514, 62, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (515, 63, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (516, 63, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (517, 63, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (518, 63, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (519, 63, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (520, 64, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (521, 64, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (522, 64, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (523, 64, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (524, 64, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (525, 65, 1, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (526, 65, 2, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (527, 65, 3, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (528, 65, 4, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (529, 65, 5, '2026-05-01 10:00:00', '2026-05-01 10:00:00');
INSERT INTO `user_video_collection` VALUES (530, 66, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (531, 66, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (532, 66, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (533, 66, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (534, 66, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (535, 66, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (536, 66, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (537, 66, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (538, 67, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (539, 67, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (540, 67, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (541, 67, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (542, 67, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (543, 67, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (544, 67, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (545, 67, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (546, 68, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (547, 68, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (548, 68, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (549, 68, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (550, 68, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (551, 68, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (552, 68, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (553, 68, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (554, 69, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (555, 69, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (556, 69, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (557, 69, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (558, 69, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (559, 69, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (560, 69, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (561, 69, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (562, 70, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (563, 70, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (564, 70, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (565, 70, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (566, 70, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (567, 70, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (568, 70, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (569, 70, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (570, 71, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (571, 71, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (572, 71, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (573, 71, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (574, 71, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (575, 71, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (576, 71, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (577, 71, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (578, 72, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (579, 72, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (580, 72, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (581, 72, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (582, 72, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (583, 72, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (584, 72, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (585, 72, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (586, 73, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (587, 73, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (588, 73, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (589, 73, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (590, 73, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (591, 73, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (592, 73, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (593, 73, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (594, 74, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (595, 74, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (596, 74, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (597, 74, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (598, 74, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (599, 74, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (600, 74, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (601, 74, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (602, 75, 6, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (603, 75, 7, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (604, 75, 8, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (605, 75, 9, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (606, 75, 10, '2026-05-02 10:00:00', '2026-05-02 10:00:00');
INSERT INTO `user_video_collection` VALUES (607, 75, 1, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (608, 75, 2, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (609, 75, 3, '2026-05-02 11:00:00', '2026-05-02 11:00:00');
INSERT INTO `user_video_collection` VALUES (610, 76, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (611, 76, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (612, 76, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (613, 76, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (614, 76, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (615, 77, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (616, 77, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (617, 77, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (618, 77, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (619, 77, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (620, 78, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (621, 78, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (622, 78, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (623, 78, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (624, 78, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (625, 79, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (626, 79, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (627, 79, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (628, 79, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (629, 79, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (630, 80, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (631, 80, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (632, 80, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (633, 80, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (634, 80, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (635, 81, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (636, 81, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (637, 81, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (638, 81, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (639, 81, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (640, 82, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (641, 82, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (642, 82, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (643, 82, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (644, 82, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (645, 83, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (646, 83, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (647, 83, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (648, 83, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (649, 83, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (650, 84, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (651, 84, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (652, 84, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (653, 84, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (654, 84, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (655, 85, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (656, 85, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (657, 85, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (658, 85, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (659, 85, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (660, 86, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (661, 86, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (662, 86, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (663, 86, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (664, 86, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (665, 87, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (666, 87, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (667, 87, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (668, 87, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (669, 87, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (670, 88, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (671, 88, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (672, 88, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (673, 88, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (674, 88, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (675, 89, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (676, 89, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (677, 89, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (678, 89, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (679, 89, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (680, 90, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (681, 90, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (682, 90, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (683, 90, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (684, 90, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (685, 91, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (686, 91, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (687, 91, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (688, 91, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (689, 91, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (690, 92, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (691, 92, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (692, 92, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (693, 92, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (694, 92, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (695, 93, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (696, 93, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (697, 93, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (698, 93, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (699, 93, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (700, 94, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (701, 94, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (702, 94, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (703, 94, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (704, 94, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (705, 95, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (706, 95, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (707, 95, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (708, 95, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (709, 95, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (710, 96, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (711, 96, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (712, 96, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (713, 96, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (714, 96, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (715, 97, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (716, 97, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (717, 97, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (718, 97, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (719, 97, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (720, 98, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (721, 98, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (722, 98, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (723, 98, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (724, 98, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (725, 99, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (726, 99, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (727, 99, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (728, 99, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (729, 99, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (735, 101, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (736, 101, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (737, 101, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (738, 101, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (739, 101, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (740, 102, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (741, 102, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (742, 102, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (743, 102, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (744, 102, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (745, 103, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (746, 103, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (747, 103, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (748, 103, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (749, 103, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (750, 104, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (751, 104, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (752, 104, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (753, 104, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (754, 104, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (755, 105, 2, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (756, 105, 7, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (757, 105, 11, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (758, 105, 15, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (759, 105, 20, '2026-05-03 10:00:00', '2026-05-03 10:00:00');
INSERT INTO `user_video_collection` VALUES (760, 6, 1, '2026-05-15 18:11:54', '2026-05-15 18:11:54');
INSERT INTO `user_video_collection` VALUES (761, 106, 3, '2026-05-19 10:39:50', '2026-05-19 10:39:50');
INSERT INTO `user_video_collection` VALUES (762, 106, 4, '2026-05-19 10:39:54', '2026-05-19 10:39:54');
INSERT INTO `user_video_collection` VALUES (763, 106, 2, '2026-05-19 10:39:59', '2026-05-19 10:39:59');

-- ----------------------------
-- Table structure for video
-- ----------------------------
DROP TABLE IF EXISTS `video`;
CREATE TABLE `video`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '视频ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频标题',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '封面图URL',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频链接',
  `tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签(逗号分隔)',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '播放量',
  `duration` int NULL DEFAULT NULL COMMENT '时长(秒)',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0-下架,1-上架',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '健身视频表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of video
-- ----------------------------
INSERT INTO `video` VALUES (1, '晨间燃脂HIIT 12分钟', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '减脂,HIIT,平和质', 1580, 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (2, '办公室拉伸舒缓训练', 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=800', 'https://www.w3schools.com/html/movie.mp4', '拉伸,久坐,气郁质', 1032, 540, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (3, '居家核心力量入门', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '核心,增肌,痰湿质', 2210, 900, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (4, '八段锦跟练放松版', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800', 'https://www.w3schools.com/html/movie.mp4', '中医,养生,平和质', 3120, 960, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (5, '晚间冥想呼吸训练', 'https://images.unsplash.com/photo-1472396961693-142e6e269027?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '减压,睡眠,气虚质', 1890, 600, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (6, '弹力带全身激活训练', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800', 'https://www.w3schools.com/html/movie.mp4', '塑形,居家,阳虚质', 1468, 780, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (7, '低冲击有氧踏步 20分钟', 'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '有氧,入门,气虚质', 520, 1200, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (8, '肩颈理疗瑜伽', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800', 'https://www.w3schools.com/html/movie.mp4', '瑜伽,肩颈,血瘀质', 890, 660, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (9, '室内单车燃脂训练', 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '有氧,单车,湿热质', 1120, 840, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (10, '睡前放松伸展 15分钟', 'https://images.unsplash.com/photo-1508672019048-805c876b667e?w=800', 'https://www.w3schools.com/html/movie.mp4', '睡眠,拉伸,气郁质', 760, 900, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (11, '全身哑铃塑形 25分钟', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '哑铃,塑形,平和质', 445, 1500, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (12, '膝关节友好走路训练', 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800', 'https://www.w3schools.com/html/movie.mp4', '低冲击,步行,气虚质', 332, 1080, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (13, '普拉提核心稳定入门', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '普拉提,核心,痰湿质', 678, 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (14, '跳绳间歇燃脂 12分钟', 'https://images.unsplash.com/photo-1594882645126-14020914d58d?w=800', 'https://www.w3schools.com/html/movie.mp4', '跳绳,HIIT,湿热质', 1205, 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (15, '晨间唤醒流瑜伽', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '瑜伽,晨间,气郁质', 556, 840, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (16, '壶铃摇摆基础教学', 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=800', 'https://www.w3schools.com/html/movie.mp4', '壶铃,力量,阳虚质', 423, 600, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (17, '体态矫正靠墙训练', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '体态,矫正,血瘀质', 289, 480, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (18, '水中健身操跟练', 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=800', 'https://www.w3schools.com/html/movie.mp4', '有氧,关节友好,特禀质', 198, 1320, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (19, '腹肌撕裂者初级版', 'https://images.unsplash.com/photo-1576678927484-cc907957088c?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '腹肌,核心,平和质', 1540, 660, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (20, '办公室微运动 8分钟', 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=800', 'https://www.w3schools.com/html/movie.mp4', '久坐,微运动,气虚质', 2100, 480, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (21, '太极二十四式简化教学', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '太极,养生,阴虚质', 2890, 1800, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (22, '战绳爆发力训练', 'https://images.unsplash.com/photo-1434682882578-f47efa33d62f?w=800', 'https://www.w3schools.com/html/movie.mp4', '战绳,爆发力,痰湿质', 612, 540, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (23, '泡沫轴全身放松', 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '放松,恢复,血瘀质', 834, 420, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (24, '亲子互动体能游戏', 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800', 'https://www.w3schools.com/html/movie.mp4', '亲子,趣味,平和质', 367, 600, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (25, '登山机爬坡燃脂', 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '有氧,爬坡,湿热质', 501, 900, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (26, '芭蕾形体基础训练', 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800', 'https://www.w3schools.com/html/movie.mp4', '形体,芭蕾,气郁质', 712, 1020, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (27, '敏捷梯脚步训练', 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '敏捷,协调,阳虚质', 298, 480, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (28, '抗阻带胸背训练', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800', 'https://www.w3schools.com/html/movie.mp4', '胸背,抗阻,气虚质', 889, 780, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (29, '正念行走冥想引导', 'https://images.unsplash.com/photo-1472396961693-142e6e269027?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '正念,冥想,阴虚质', 445, 540, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (30, '综合体能循环训练', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800', 'https://www.w3schools.com/html/movie.mp4', '循环,体能,平和质', 1722, 1200, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (31, '气虚质补气呼吸与轻有氧', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '气虚质,有氧,呼吸', 412, 600, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (32, '阳虚质温阳舒缓八段锦', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800', 'https://www.w3schools.com/html/movie.mp4', '阳虚质,八段锦,舒缓', 523, 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (33, '阴虚质阴液养护拉伸', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '阴虚质,拉伸,睡眠', 388, 540, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (34, '痰湿质代谢提升走步训练', 'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=800', 'https://www.w3schools.com/html/movie.mp4', '痰湿质,走步,代谢', 601, 900, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (35, '湿热质清热排汗有氧操', 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '湿热质,有氧,排汗', 477, 660, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (36, '血瘀质循环促进筋膜放松', 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=800', 'https://www.w3schools.com/html/movie.mp4', '血瘀质,筋膜,放松', 355, 480, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (37, '气郁质疏肝理气瑜伽流动', 'https://images.unsplash.com/photo-1508672019048-805c876b667e?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '气郁质,瑜伽,疏肝', 499, 780, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (38, '特禀质低刺激室内有氧', 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=800', 'https://www.w3schools.com/html/movie.mp4', '特禀质,低刺激,室内', 266, 540, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (39, '平和质综合体能维持训练', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800', 'https://www.w3schools.com/html/mov_bbb.mp4', '平和质,体能,维持', 812, 840, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (40, '气虚质下肢力量温和进阶', 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800', 'https://www.w3schools.com/html/movie.mp4', '气虚质,力量,下肢', 294, 720, 1, '2026-05-15 14:35:38', '2026-05-15 14:35:38');
INSERT INTO `video` VALUES (41, '111', '/uploads/images/d348eace-015a-4675-a44c-e601ea418dbe.png', '/uploads/videos/65044d32-eb7e-40d3-ad59-dfa7f215f010.mp4', '111', 0, 0, 1, '2026-05-19 16:44:33', '2026-05-19 16:44:33');

-- ----------------------------
-- Procedure structure for GenerateAssessmentAndPlan
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateAssessmentAndPlan`;
delimiter ;;
CREATE PROCEDURE `GenerateAssessmentAndPlan`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_user_id INT;
    DECLARE v_assessment_id INT;           -- ★ 新增变量，保存评估ID
    DECLARE v_plan_id INT;
    DECLARE v_total_score INT;
    DECLARE v_level TINYINT;
    DECLARE v_phy_score INT;
    DECLARE v_psy_score INT;
    DECLARE v_life_score INT;
    DECLARE v_constitution VARCHAR(20);
    DECLARE v_diagnosis TEXT;
    DECLARE v_plan_type TINYINT;
    DECLARE v_plan_name VARCHAR(100);
    DECLARE v_plan_content TEXT;
    DECLARE v_suitable_constitution VARCHAR(50);
    DECLARE v_suitable_level VARCHAR(20);
    DECLARE v_tags VARCHAR(100);
    DECLARE v_assess_time DATETIME;

    DECLARE cur_users CURSOR FOR SELECT id FROM `user`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur_users;

    read_loop: LOOP
        FETCH cur_users INTO v_user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 随机亚健康等级
        SET v_level = ELT(1 + FLOOR(RAND() * 4), 0, 1, 2, 3);
        SET v_total_score = CASE v_level
            WHEN 0 THEN FLOOR(0 + RAND() * 30)
            WHEN 1 THEN FLOOR(30 + RAND() * 25)
            WHEN 2 THEN FLOOR(55 + RAND() * 25)
            WHEN 3 THEN FLOOR(80 + RAND() * 20)
        END;
        SET v_phy_score = FLOOR(v_total_score * (0.3 + RAND() * 0.2));
        SET v_psy_score = FLOOR(v_total_score * (0.2 + RAND() * 0.2));
        SET v_life_score = v_total_score - v_phy_score - v_psy_score;
        IF v_life_score < 0 THEN SET v_life_score = 0; END IF;

        -- 随机中医体质
        SET v_constitution = ELT(1 + FLOOR(RAND() * 9), '平和质','气虚质','阳虚质','阴虚质','痰湿质','湿热质','血瘀质','气郁质','特禀质');

        -- 诊断描述
        SET v_diagnosis = CONCAT(
            '亚健康等级：',
            CASE v_level
                WHEN 0 THEN '健康'
                WHEN 1 THEN '轻度亚健康'
                WHEN 2 THEN '中度亚健康'
                WHEN 3 THEN '重度亚健康'
            END,
            '，中医体质：', v_constitution,
            '。根据评估结果制定个性化调理方案。'
        );

        SET v_assess_time = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY);

        -- 插入健康评估（方案id先置NULL）
        INSERT INTO health_assessment (
            user_id, total_score, level,
            physiological_score, psychological_score, lifestyle_score,
            diagnosis, constitution_type, regimen_plan_id, assess_time, create_time
        ) VALUES (
            v_user_id, v_total_score, v_level,
            v_phy_score, v_psy_score, v_life_score,
            v_diagnosis, v_constitution, NULL, v_assess_time, NOW()
        );
        SET v_assessment_id = LAST_INSERT_ID();   -- ★ 保存评估ID

        -- 生成个性化调理方案
        SET v_plan_type = 1 + FLOOR(RAND() * 3);
        SET v_suitable_constitution = v_constitution;
        SET v_suitable_level = CAST(v_level AS CHAR);

        SET v_plan_name = CONCAT(
            '【', v_constitution, '调理】',
            CASE v_plan_type
                WHEN 1 THEN '药膳食疗'
                WHEN 2 THEN '穴位按摩'
                WHEN 3 THEN '运动养生'
            END,
            '方案 - ',
            CASE v_level
                WHEN 0 THEN '日常保健'
                WHEN 1 THEN '轻度调养'
                WHEN 2 THEN '中度干预'
                WHEN 3 THEN '重点调理'
            END
        );

        -- 方案内容（同前）
        SET v_plan_content = CASE v_plan_type
            WHEN 1 THEN CONCAT(
                '【药膳食疗方案】\n',
                '针对您的', v_constitution, '与亚健康等级，推荐以下食疗：\n',
                CASE v_constitution
                    WHEN '平和质' THEN '保持饮食均衡，建议多食山药、薏米、红枣粥，每周3次。'
                    WHEN '气虚质' THEN '宜补气健脾，推荐黄芪炖鸡、小米山药粥、党参排骨汤。忌生冷油腻。'
                    WHEN '阳虚质' THEN '温阳散寒，食用当归生姜羊肉汤、韭菜炒核桃、杜仲腰花。忌寒凉食物。'
                    WHEN '阴虚质' THEN '滋阴润燥，推荐银耳莲子羹、百合炒鸡蛋、石斛老鸭汤。少吃辛辣。'
                    WHEN '痰湿质' THEN '健脾化湿，多食冬瓜薏米汤、陈皮瘦肉粥、赤小豆鲫鱼汤。少食肥甘。'
                    WHEN '湿热质' THEN '清热利湿，可选择绿豆薏仁粥、凉拌苦瓜、茯苓白术汤。忌酒类。'
                    WHEN '血瘀质' THEN '活血化瘀，建议山楂红糖水、丹参田七炖鸡、黑木耳炒菜。'
                    WHEN '气郁质' THEN '理气解郁，推荐玫瑰花茶、佛手柑粥、陈皮瘦肉汤。'
                    WHEN '特禀质' THEN '益气固表，食用黄芪防风炖瘦肉、红枣桂圆粥，避免过敏原。'
                END,
                '\n每日服用1-2次，坚持4周为周期。注意事项：具体药材用量请咨询中医师。'
            )
            WHEN 2 THEN CONCAT(
                '【穴位按摩方案】\n',
                '针对您的', v_constitution, '，精选以下穴位：\n',
                CASE v_constitution
                    WHEN '平和质' THEN '日常保健可选足三里、涌泉、神阙，每穴按揉3分钟。'
                    WHEN '气虚质' THEN '补气要穴：足三里、气海、关元，每穴艾灸或按揉5分钟。'
                    WHEN '阳虚质' THEN '温阳要穴：肾俞、命门、神阙，可用艾条温和灸15分钟。'
                    WHEN '阴虚质' THEN '滋阴清热：太溪、三阴交、涌泉，指压按摩至酸胀。'
                    WHEN '痰湿质' THEN '化痰祛湿：丰隆、阴陵泉、中脘，按揉5分钟。'
                    WHEN '湿热质' THEN '清热利湿：曲池、合谷、阴陵泉，按揉或刮痧。'
                    WHEN '血瘀质' THEN '活血化瘀：血海、膈俞、合谷，按揉至局部发热。'
                    WHEN '气郁质' THEN '疏肝理气：太冲、膻中、肝俞，按揉配合深呼吸。'
                    WHEN '特禀质' THEN '固表抗敏：迎香、足三里、大椎，艾灸或按摩。'
                END,
                '\n每日早晚各一次，持之以恒。注意：经期、孕期请遵医嘱。'
            )
            WHEN 3 THEN CONCAT(
                '【运动养生方案】\n',
                '针对您的', v_constitution, '与亚健康状态，推荐以下运动：\n',
                CASE v_constitution
                    WHEN '平和质' THEN '综合训练：慢跑、游泳、八段锦，每周3-5次，每次30分钟。'
                    WHEN '气虚质' THEN '温和运动：太极拳、散步、瑜伽，避免大汗，每周4次。'
                    WHEN '阳虚质' THEN '轻缓升阳：快走、八段锦、五禽戏，最好在上午进行。'
                    WHEN '阴虚质' THEN '养阴运动：游泳、静心瑜伽、太极拳，避免高温暴晒。'
                    WHEN '痰湿质' THEN '有氧减脂：慢跑、登山、健身操，出汗为度，每周5次。'
                    WHEN '湿热质' THEN '排湿清热：高强度间歇跑、游泳、羽毛球，注意补水。'
                    WHEN '血瘀质' THEN '助血运行：舞蹈、骑自行车、太极拳，拉伸放松。'
                    WHEN '气郁质' THEN '解郁运动：户外骑行、登山、团体运动，多接触自然。'
                    WHEN '特禀质' THEN '温和锻炼：室内瑜伽、八段锦，过敏季避免户外。'
                END,
                '\n建议每周至少3-5次，每次30-60分钟，循序渐进，忌过于疲劳。'
            )
        END;

        SET v_tags = CONCAT(v_constitution, ',',
            CASE v_plan_type WHEN 1 THEN '药膳' WHEN 2 THEN '穴位按摩' WHEN 3 THEN '运动' END,
            ',',
            CASE v_level WHEN 0 THEN '保健' WHEN 1 THEN '轻调' WHEN 2 THEN '中调' WHEN 3 THEN '重调' END
        );

        -- 插入方案
        INSERT INTO regimen_plan (
            name, plan_type, content, suitable_constitution,
            suitable_level, tags, status, create_time
        ) VALUES (
            v_plan_name, v_plan_type, v_plan_content, v_suitable_constitution,
            v_suitable_level, v_tags, 1, NOW()
        );
        SET v_plan_id = LAST_INSERT_ID();   -- 保存方案ID

        -- ★ 用变量更新，避免子查询引用目标表
        UPDATE health_assessment SET regimen_plan_id = v_plan_id WHERE id = v_assessment_id;

    END LOOP;

    CLOSE cur_users;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GenerateHealthData
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateHealthData`;
delimiter ;;
CREATE PROCEDURE `GenerateHealthData`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_user_id INT;
    DECLARE v_record_time DATETIME;
    DECLARE v_height DECIMAL(5,2);
    DECLARE v_weight DECIMAL(5,2);
    DECLARE v_systolic INT;
    DECLARE v_diastolic INT;
    DECLARE v_fasting_glucose DECIMAL(4,2);
    DECLARE v_total_cholesterol DECIMAL(4,2);
    DECLARE v_is_abnormal TINYINT;
    DECLARE v_data_type TINYINT;
    DECLARE v_count INT;

    -- 游标：遍历所有用户
    DECLARE cur_users CURSOR FOR SELECT id FROM `user`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur_users;

    read_loop: LOOP
        FETCH cur_users INTO v_user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- ========== 1. 身高体重（每个用户1条） ==========
        SET v_data_type = 1;
        -- 身高：150~190cm
        SET v_height = 150 + RAND() * 40;
        -- 体重：40~110kg，且 BMI 在 14~38 之间浮动
        SET v_weight = 40 + RAND() * 70;
        -- 根据 BMI 判定异常
        SET v_is_abnormal = 0;
        IF (v_weight / (v_height/100 * v_height/100)) < 18.5 OR (v_weight / (v_height/100 * v_height/100)) >= 28 THEN
            SET v_is_abnormal = 1;
        ELSEIF (v_weight / (v_height/100 * v_height/100)) BETWEEN 24 AND 27.999 THEN
            SET v_is_abnormal = 0.5; -- 随机判断，下同
             IF RAND() > 0.5 THEN SET v_is_abnormal = 1; ELSE SET v_is_abnormal = 0; END IF;
        END IF;
        SET v_record_time = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY);
        INSERT INTO health_data (user_id, data_type, height, weight, record_time, is_abnormal, create_time)
        VALUES (v_user_id, v_data_type, v_height, v_weight, v_record_time, v_is_abnormal, NOW());

        -- ========== 2. 血压（3~5条） ==========
        SET v_data_type = 2;
        SET v_count = 3 + FLOOR(RAND() * 3);  -- 3/4/5条
        WHILE v_count > 0 DO
            -- 收缩压：80~200
            SET v_systolic = 80 + FLOOR(RAND() * 120);
            -- 舒张压：50~120
            SET v_diastolic = 50 + FLOOR(RAND() * 70);
            -- 异常判定（参考量表阈值）
            SET v_is_abnormal = 0;
            IF (v_systolic >= 140 OR v_diastolic <= 90) THEN
                SET v_is_abnormal = 1;
            ELSEIF (v_systolic BETWEEN 120 AND 139) OR (v_diastolic BETWEEN 80 AND 89) THEN
                IF RAND() > 0.4 THEN SET v_is_abnormal = 1; END IF;
            END IF;
            SET v_record_time = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY);
            INSERT INTO health_data (user_id, data_type, systolic, diastolic, record_time, is_abnormal, create_time)
            VALUES (v_user_id, v_data_type, v_systolic, v_diastolic, v_record_time, v_is_abnormal, NOW());
            SET v_count = v_count - 1;
        END WHILE;

        -- ========== 3. 空腹血糖（3~5条） ==========
        SET v_data_type = 3;
        SET v_count = 3 + FLOOR(RAND() * 3);
        WHILE v_count > 0 DO
            -- 血糖：2.5~12.0 mmol/L
            SET v_fasting_glucose = 2.5 + RAND() * 9.5;
            SET v_is_abnormal = 0;
            IF v_fasting_glucose >= 7.0 OR v_fasting_glucose <= 3.9 THEN
                SET v_is_abnormal = 1;
            ELSEIF v_fasting_glucose BETWEEN 6.1 AND 6.9 THEN
                IF RAND() > 0.4 THEN SET v_is_abnormal = 1; END IF;
            END IF;
            SET v_record_time = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY);
            INSERT INTO health_data (user_id, data_type, fasting_glucose, record_time, is_abnormal, create_time)
            VALUES (v_user_id, v_data_type, v_fasting_glucose, v_record_time, v_is_abnormal, NOW());
            SET v_count = v_count - 1;
        END WHILE;

        -- ========== 4. 血脂（总胆固醇，2~3条） ==========
        SET v_data_type = 4;
        SET v_count = 2 + FLOOR(RAND() * 2);  -- 2或3条
        WHILE v_count > 0 DO
            -- 总胆固醇：2.5~8.5 mmol/L
            SET v_total_cholesterol = 2.5 + RAND() * 6.0;
            SET v_is_abnormal = 0;
            IF v_total_cholesterol > 6.2 THEN
                SET v_is_abnormal = 1;
            ELSEIF v_total_cholesterol BETWEEN 5.2 AND 6.2 THEN
                IF RAND() > 0.4 THEN SET v_is_abnormal = 1; END IF;
            END IF;
            SET v_record_time = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY);
            INSERT INTO health_data (user_id, data_type, total_cholesterol, record_time, is_abnormal, create_time)
            VALUES (v_user_id, v_data_type, v_total_cholesterol, v_record_time, v_is_abnormal, NOW());
            SET v_count = v_count - 1;
        END WHILE;

    END LOOP;

    CLOSE cur_users;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GenerateRecipes
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateRecipes`;
delimiter ;;
CREATE PROCEDURE `GenerateRecipes`()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE recipe_names TEXT DEFAULT 
        '番茄炒蛋|青椒肉丝|清炒西兰花|紫菜蛋花汤|红烧排骨|蒜蓉粉丝虾|麻婆豆腐|凉拌黄瓜|回锅肉|鱼香肉丝|地三鲜|宫保鸡丁|糖醋里脊|水煮牛肉|酸菜鱼|小炒肉|白灼菜心|香菇鸡汤|冬瓜排骨汤|罗宋汤';
    WHILE i < 200 DO
        INSERT INTO recipe (name, cover, ingredients, steps, tags, suitable_constitution, view_count, status, create_time)
        VALUES (
            CONCAT(
                SUBSTRING_INDEX(SUBSTRING_INDEX(recipe_names, '|', 1 + (i % 20)), '|', -1),
                '（改良版', i+1, '）'
            ),
            CONCAT('https://picsum.photos/id/', 2000 + i, '/400/300'),
            '主料：精选食材500g，辅料：姜葱蒜适量，调味料：盐、生抽、料酒少许。',
            '1.食材清洗切配；2.热锅冷油，爆香辅料；3.加入主料翻炒至变色；4.加入调料和少量水焖煮；5.收汁出锅装盘。',
            '家常菜,健康饮食',
            ELT(1 + FLOOR(RAND()*9), '平和质','气虚质','阳虚质','阴虚质','痰湿质','湿热质','血瘀质','气郁质','特禀质'),
            FLOOR(50 + RAND() * 2000),
            1,
            '2026-04-01 08:00:00' + INTERVAL (i * 3) MINUTE
        );
        SET i = i + 1;
    END WHILE;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GenerateSocialPosts
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateSocialPosts`;
delimiter ;;
CREATE PROCEDURE `GenerateSocialPosts`()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_user_id INT;
    DECLARE post_texts TEXT DEFAULT 
        '今天开始健康打卡，坚持下去！|分享一道美味又低脂的午餐，好吃不怕胖。|晨跑5公里完成，精神满满！|新学了一套办公室拉伸操，肩颈瞬间轻松了。|推荐这个八段锦视频，练了一周感觉睡眠好多了。|中伏天喝碗绿豆汤，解暑又养生。|坚持艾灸一个月，手脚冰凉改善很多。|社区义诊体验了推拿，老中医手法真不错。|今日份运动：游泳800米，舒服！|减脂餐打卡第15天，体重下降2kg！';
    DECLARE img_urls TEXT DEFAULT 
        'https://picsum.photos/id/300/400/300|https://picsum.photos/id/301/400/300|https://picsum.photos/id/302/400/300|https://picsum.photos/id/303/400/300|https://picsum.photos/id/304/400/300|https://picsum.photos/id/305/400/300|https://picsum.photos/id/306/400/300|https://picsum.photos/id/307/400/300|https://picsum.photos/id/308/400/300|https://picsum.photos/id/309/400/300';
    DECLARE v_content VARCHAR(500);
    DECLARE v_images VARCHAR(500);
    DECLARE v_tags VARCHAR(100);
    
    WHILE i < 200 DO
        SELECT id INTO v_user_id FROM `user` ORDER BY RAND() LIMIT 1;
        
        -- 安全截取内容，确保不超 varchar(500)
        SET v_content = LEFT(
            SUBSTRING_INDEX(SUBSTRING_INDEX(post_texts, '|', 1 + (i % 10)), '|', -1),
            500
        );
        
        -- 随机1~2张图片
        SET v_images = SUBSTRING_INDEX(SUBSTRING_INDEX(img_urls, '|', 1 + (i % 10)), '|', -1);
        IF RAND() < 0.5 THEN
            SET v_images = LEFT(CONCAT(v_images, ',', 
                SUBSTRING_INDEX(SUBSTRING_INDEX(img_urls, '|', 1 + ((i+1) % 10)), '|', -1)), 500);
        END IF;
        
        SET v_tags = CONCAT('#', ELT(1 + FLOOR(RAND()*4), '健康生活', '养生打卡', '运动记录', '食谱分享'));
        
        INSERT INTO social_post (user_id, content, images, tags, like_count, comment_count, status, create_time)
        VALUES (
            v_user_id,
            v_content,
            v_images,
            v_tags,
            FLOOR(RAND() * 50),
            FLOOR(RAND() * 10),
            1,
            '2026-03-20 12:00:00' + INTERVAL i * 30 MINUTE
        );
        SET i = i + 1;
    END WHILE;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GenerateUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateUsers`;
delimiter ;;
CREATE PROCEDURE `GenerateUsers`()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_gender TINYINT;
    DECLARE v_age INT;
    DECLARE v_register_time DATETIME;
    DECLARE v_username VARCHAR(50);
    DECLARE v_exists INT DEFAULT 1;
    DECLARE surnames VARCHAR(600) DEFAULT '赵,钱,孙,李,周,吴,郑,王,冯,陈,褚,卫,蒋,沈,韩,杨,朱,秦,尤,许,何,吕,施,张,孔,曹,严,华,金,魏,陶,姜,戚,谢,邹,喻,柏,水,窦,章,云,苏,潘,葛,奚,范,彭,郎,鲁,韦,昌,马,苗,凤,花,方,俞,任,袁,柳,酆,鲍,史,唐,费,廉,岑,薛,雷,贺,倪,汤,滕,殷,罗,毕,郝,邬,安,常,乐,于,时,傅,皮,卞,齐,康,伍,余,元,卜,顾,孟,平,黄,和,穆,萧,尹';
    DECLARE male_names VARCHAR(600) DEFAULT '伟,强,磊,涛,军,勇,杰,鹏,明,亮,超,飞,龙,虎,豹,刚,毅,峰,浩,然,彬,文,博,睿,轩,宇,泽,霖,逸,远,达,通,和,平,安,宁,顺,祥,瑞,康,健,志,宏,光,辉,耀,宗,祖,德,兴';
    DECLARE female_names VARCHAR(600) DEFAULT '芳,敏,静,丽,娜,娟,秀,英,兰,凤,洁,琳,婷,雪,云,月,霞,花,燕,红,美,雨,佳,琪,瑶,婉,贞,莉,慧,怡,君,梅,蕾,晶,悦,晴,彤,萱,颖,瑶,菁,菲,曼,珊,蕾,欣,芸,瑾,蓉,玲';
    DECLARE phones_prefix VARCHAR(100) DEFAULT '138,139,150,151,152,158,159,186,187,188';

    WHILE i < 200 DO
        SET v_gender = FLOOR(RAND() * 2);
        SET v_age = 18 + FLOOR(RAND() * 48);
        SET v_register_time = '2026-03-01 00:00:00' + INTERVAL FLOOR(RAND() * 61) DAY 
                            + INTERVAL FLOOR(RAND() * 86400) SECOND;
        
        -- 重名检查循环：直到生成一个数据库内不存在的用户名为止
        SET v_exists = 1;
        WHILE v_exists > 0 DO
            SET v_username = CONCAT(
                SUBSTRING_INDEX(SUBSTRING_INDEX(surnames, ',', 1 + FLOOR(RAND() * 100)), ',', -1),
                IF(v_gender = 1,
                   SUBSTRING_INDEX(SUBSTRING_INDEX(male_names, ',', 1 + FLOOR(RAND() * 50)), ',', -1),
                   SUBSTRING_INDEX(SUBSTRING_INDEX(female_names, ',', 1 + FLOOR(RAND() * 50)), ',', -1)
                )
            );
            SELECT COUNT(*) INTO v_exists FROM `user` WHERE username = v_username;
        END WHILE;
        
        INSERT INTO `user` (`username`, `password`, `phone`, `email`, `avatar`, `age`, `gender`, `status`, `social_status`, `create_time`, `update_time`)
        VALUES (
            v_username,
            '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5Eh',
            CONCAT(
                SUBSTRING_INDEX(SUBSTRING_INDEX(phones_prefix, ',', 1 + FLOOR(RAND() * 10)), ',', -1),
                LPAD(FLOOR(RAND() * 100000000), 8, '0')
            ),
            CONCAT('user', i, '@health.com'),
            CONCAT('https://picsum.photos/id/', 100 + i, '/200/200'),
            v_age,
            v_gender,
            0,
            0,
            v_register_time,
            NULL
        );
        SET i = i + 1;
    END WHILE;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for GenerateVideos
-- ----------------------------
DROP PROCEDURE IF EXISTS `GenerateVideos`;
delimiter ;;
CREATE PROCEDURE `GenerateVideos`()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE titles TEXT DEFAULT 
        '全身拉伸放松|办公室肩颈舒缓|八段锦教学|太极二十四式|晨间活力瑜伽|睡前助眠冥想|高效燃脂操|核心力量训练|拳击有氧操|哑铃塑形|翘臀训练秘籍|腿部拉伸全攻略|舒缓腰背疼痛|改善圆肩驼背|冥想入门|经络拍打操|中医养生操|护眼明目训练|产后修复瑜伽|儿童体能训练';
    WHILE i < 200 DO
        INSERT INTO video (title, cover, url, tags, view_count, duration, status, create_time)
        VALUES (
            CONCAT(
                LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(titles, '|', 1 + (i % 20)), '|', -1), 50),
                ' 第', i+1, '期'
            ),
            CONCAT('https://picsum.photos/id/', 1000 + i, '/400/300'),
            CONCAT('https://example.com/video/', i+1, '.mp4'),
            ELT(1 + FLOOR(RAND()*5), '健身,瑜伽', '养生,太极', '减脂,有氧', '拉伸,康复', '冥想,助眠'),
            FLOOR(100 + RAND() * 5000),
            FLOOR(180 + RAND() * 1200),
            1,
            '2026-03-15 10:00:00' + INTERVAL i HOUR
        );
        SET i = i + 1;
    END WHILE;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
