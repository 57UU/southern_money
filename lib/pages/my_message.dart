import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_notification.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/utilities.dart';

class MyMessage extends StatefulWidget {
  const MyMessage({super.key});

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  final notifications = getIt<ApiNotificationService>();

  List<NotificationResponse> _notificationList = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  int _unreadCount = 0;

  final ScrollController _scrollController = ScrollController();

  // 获取通知类型图标
  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'system':
        return Icons.info_outline;
      case 'comment':
        return Icons.comment;
      case 'like':
        return Icons.favorite;
      case 'follow':
        return Icons.person_add;
      case 'trade':
        return Icons.shopping_cart;
      default:
        return Icons.notifications;
    }
  }

  // 获取通知标题
  String _getNotificationTitle(String type) {
    switch (type.toLowerCase()) {
      case 'system':
        return '系统通知';
      case 'comment':
        return '评论通知';
      case 'like':
        return '点赞通知';
      case 'follow':
        return '关注通知';
      case 'trade':
        return '交易通知';
      default:
        return '新消息';
    }
  }

  // 获取通知类型颜色
  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'system':
        return Colors.blue;
      case 'comment':
        return Colors.green;
      case 'like':
        return Colors.red;
      case 'follow':
        return Colors.purple;
      case 'trade':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _loadUnreadCount();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 加载通知列表
  Future<void> _loadNotifications({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (isRefresh) {
        _currentPage = 1;
        _notificationList = [];
        _hasMore = true;
      }
    });

    try {
      final response = await notifications.getMyNotifications(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.success && response.data != null) {
        setState(() {
          if (_currentPage == 1) {
            _notificationList = response.data!.items;
          } else {
            _notificationList.addAll(response.data!.items);
          }

          _hasMore =
              _notificationList.length < (response.data!.totalCount ?? 0);
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? '加载失败';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  // 加载未读数量
  Future<void> _loadUnreadCount() async {
    try {
      final response = await notifications.getUnreadCount();
      if (response.success && response.data != null) {
        setState(() {
          _unreadCount = response.data!;
        });
      }
    } catch (e) {
      // 忽略错误，不影响主流程
    }
  }

  // 刷新通知列表
  Future<void> _refreshNotifications() async {
    await _loadNotifications(isRefresh: true);
    await _loadUnreadCount();
  }

  // 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  // 加载更多
  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _loadNotifications();
  }

  // 标记为已读
  Future<void> _markAsRead(String notificationId) async {
    try {
      final response = await notifications.markAsRead(
        notificationIds: [notificationId],
      );

      if (response.success) {
        setState(() {
          final index = _notificationList.indexWhere(
            (n) => n.id == notificationId,
          );
          if (index != -1) {
            _notificationList[index] = NotificationResponse(
              id: _notificationList[index].id,
              userId: _notificationList[index].userId,
              content: _notificationList[index].content,
              isRead: true,
              createTime: _notificationList[index].createTime,
              type: _notificationList[index].type,
            );
          }

          if (_unreadCount > 0) {
            _unreadCount--;
          }
        });
      } else {
        showInfoDialog(title: "错误", content: response.message ?? "标记失败");
      }
    } catch (e) {
      showInfoDialog(title: "错误", content: "标记失败: $e");
    }
  }

  // 全部标记为已读
  Future<void> _markAllAsRead() async {
    try {
      final response = await notifications.markAllAsRead();

      if (response.success) {
        setState(() {
          // 更新所有通知为已读状态
          _notificationList = _notificationList.map((notification) {
            return NotificationResponse(
              id: notification.id,
              userId: notification.userId,
              content: notification.content,
              isRead: true,
              createTime: notification.createTime,
              type: notification.type,
            );
          }).toList();

          _unreadCount = 0;
        });

        showInfoDialog(title: "成功", content: "所有通知已标记为已读");
      } else {
        showInfoDialog(title: "错误", content: response.message ?? "标记失败");
      }
    } catch (e) {
      showInfoDialog(title: "错误", content: "标记失败: $e");
    }
  }

  // 构建通知项
  Widget _buildNotificationItem(NotificationResponse notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: notification.isRead ? 1 : 3,
      color: notification.isRead ? null : Colors.blue.withOpacity(0.05),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(
            notification.type,
          ).withOpacity(0.2),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
          ),
        ),
        title: Text(
          _getNotificationTitle(notification.type),
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formatTimeAgo(notification.createTime),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
        },
      ),
    );
  }

  // 构建加载指示器
  Widget _buildLoadingIndicator() {
    if (!_isLoadingMore) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  // 构建错误视图
  Widget _buildErrorView() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  // 构建空视图
  Widget _buildEmptyView() {
    if (_notificationList.isNotEmpty || _isLoading)
      return const SizedBox.shrink();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          const Text('暂无消息通知'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('消息通知'),
            if (_unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        actions: [
          if (_notificationList.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'markAllRead') {
                  _markAllAsRead();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'markAllRead',
                  child: Row(
                    children: [
                      Icon(Icons.done_all),
                      SizedBox(width: 8),
                      Text('全部标记为已读'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _notificationList.length + 1,
              itemBuilder: (context, index) {
                if (index < _notificationList.length) {
                  return _buildNotificationItem(_notificationList[index]);
                } else {
                  return _buildLoadingIndicator();
                }
              },
            ),
            if (_isLoading && _notificationList.isEmpty)
              const Center(child: CircularProgressIndicator()),
            _buildErrorView(),
            _buildEmptyView(),
          ],
        ),
      ),
    );
  }
}
