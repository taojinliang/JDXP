/******************************************************************
 文件名称: HSActionSheetHelper
 系统名称: 领投宝
 模块名称: 客户端
 类 名 称: HSActionSheetHelper
 软件版权: 恒生电子股份有限公司
 功能说明: 帮助类：显示一个在屏幕下方的弹出视图（类似UIActionSheet的弹出方式）
 系统版本:
 开发人员: taojl
 开发时间: 15-06-03
 审核人员:
 相关文档:
 修改记录: 需求编号 修改日期 修改人员 修改说明
 
 ******************************************************************/


#import <UIKit/UIKit.h>

@class HSActionSheetHelper;
@protocol HSActionSheetHelperDelegate <NSObject>

- (void)doneActionSheet:(HSActionSheetHelper*)hsActionSheet;
- (void)cancelActionSheet:(HSActionSheetHelper*)hsActionSheet;

@end

@interface HSActionSheetHelper : NSObject
/**
 *  @brief  tag标志位
 */
@property(nonatomic) NSInteger tag;
/**
 *  @brief  内容视图上方的工具栏（显示“取消”、“确定”）
 */
@property (nonatomic, strong, readonly) UINavigationBar* navigationBar;
/**
 *  @brief  工具栏上的标题
 */
@property (nonatomic, copy) NSString* title;
/**
 *  @brief  委托
 */
@property (nonatomic, weak) id <HSActionSheetHelperDelegate> delegate;

/**
 *  @brief  初始化
 *  @param contentView 需要实际显示的内容视图
 *  @return 实例
 */
- (instancetype)initWithContentView:(UIView *)contentView;

/**
 *  @brief  显示，且"显示的生命周期"与指定的视图相同
 *  @param view "显示的生命周期"与此View相同：当View析构的时候，自动取消显示
 */
- (void)showLifecycleSameAsView:(UIView *)view;

/**
 *  @brief  取消显示
 */
- (void)dismiss;
@end
