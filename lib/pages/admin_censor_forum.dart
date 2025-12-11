import 'package:flutter/material.dart';
import 'package:southern_money/pages/admin_post_block_history.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_admin.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/router_utils.dart';
import 'package:southern_money/widgets/styled_card.dart';

class AdminCensorForum extends StatefulWidget {
  const AdminCensorForum({super.key});

  @override
  State<AdminCensorForum> createState() => _AdminCensorForumState();
}

class _AdminCensorForumState extends State<AdminCensorForum>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final adminService = getIt<ApiAdminService>();

  // 状态变量
  List<PostPageItemResponse> _posts = [];
  int _currentPage = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  int? _totalCount;
  bool _isBlockedFilter = false; // 过滤条件，默认显示未封禁帖子

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // 获取帖子列表
  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await adminService.getAllPosts(
        page: _currentPage,
        pageSize: _pageSize,
        isBlocked: _isBlockedFilter,
      );

      if (response.success && response.data != null) {
        setState(() {
          _posts = response.data!.items;
          _totalCount = response.data!.totalCount;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取帖子列表失败: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('获取帖子列表失败: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 处理帖子（封禁/解封）
  Future<void> _handlePost(PostPageItemResponse post, bool isBlocked) async {
    // 如果是封禁操作且帖子已经被封禁，显示提示信息
    if (isBlocked && post.isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('该帖子已经被封禁，无需重复操作'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final reasonController = TextEditingController();

    // 如果是解封操作，添加特殊说明
    String title = isBlocked ? '封禁帖子' : '解封帖子';
    String content = isBlocked
        ? '请输入封禁原因：'
        : '请输入解封原因：\n(注意：即使帖子未被封禁，解封操作也会清除举报信息)';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入处理原因',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('请输入处理原因')));
                return;
              }
              Navigator.pop(context, reasonController.text.trim());
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await adminService.handleReport(
          postId: post.id,
          isBlocked: isBlocked,
          handleReason: result,
        );

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isBlocked ? '帖子已封禁' : '帖子已解封，举报信息已清除'),
              backgroundColor: Colors.green,
            ),
          );
          _fetchPosts(); // 刷新帖子列表
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('处理失败: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('处理失败: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 过滤条件切换
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _currentPage = 1; // 点击刷新时重置到第一页
                  _fetchPosts();
                },
                icon: Icon(Icons.refresh),
              ),
              Row(
                children: [
                  const Text('显示已封禁帖子：'),
                  Switch(
                    value: _isBlockedFilter,
                    onChanged: (value) {
                      setState(() {
                        _isBlockedFilter = value;
                        _currentPage = 1; // 切换过滤条件时重置到第一页
                        _fetchPosts();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 帖子列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _posts.isEmpty
                ? const Center(child: Text('没有找到被举报的帖子'))
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return StyledCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        onTap: () {
                          popupOrNavigate(
                            context,
                            AdminPostBlockHistory(response: post),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: post.isBlocked
                                          ? Colors.red
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      post.isBlocked ? '已封禁' : '正常',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '发布者: ${post.uploader.name}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '发布时间: ${_formatDate(post.createTime)}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // 解封按钮 - 始终可用，用于清除举报信息
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          // 始终允许解封操作，无论帖子当前状态如何
                                          _handlePost(post, false);
                                        },
                                        tooltip: '解封帖子（清除举报信息）',
                                      ),
                                      const SizedBox(width: 8),
                                      // 封禁按钮 - 根据当前状态显示不同样式
                                      IconButton(
                                        icon: Icon(
                                          post.isBlocked
                                              ? Icons.block
                                              : Icons.cancel_outlined,
                                          color: post.isBlocked
                                              ? Colors.grey
                                              : Colors.red,
                                        ),
                                        onPressed: () {
                                          _handlePost(post, true);
                                        },
                                        tooltip: post.isBlocked
                                            ? '帖子已封禁'
                                            : '封禁帖子',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${post.viewCount} 浏览',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite_border,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${post.likeCount} 点赞',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.report, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${post.reportCount} 举报',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 分页控件
          if (_totalCount != null && _totalCount! > 0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                          _fetchPosts();
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('第 $_currentPage 页'),
                IconButton(
                  onPressed: _currentPage * _pageSize < _totalCount!
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                          _fetchPosts();
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
