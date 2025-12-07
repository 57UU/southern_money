import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_admin.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_request.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/common_widget.dart';

class AdminManageUser extends StatefulWidget {
  const AdminManageUser({super.key});

  @override
  State<AdminManageUser> createState() => _AdminManageUserState();
}

class _AdminManageUserState extends State<AdminManageUser>
    with AutomaticKeepAliveClientMixin {
  final adminService = getIt<ApiAdminService>();
  final imageService = getIt<ApiImageService>();

  // 状态管理
  List<AdminUserResponse> _users = [];
  int _currentPage = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  String _searchQuery = '';
  bool? _isBlockedFilter;
  bool? _isAdminFilter;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // 获取用户列表
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    final request = AdminUsersRequest(
      page: _currentPage,
      pageSize: _pageSize,
      search: _searchQuery.isEmpty ? null : _searchQuery,
      isBlocked: _isBlockedFilter,
      isAdmin: _isAdminFilter,
    );

    final response = await adminService.getAllUsers(request: request);

    setState(() {
      _isLoading = false;
      if (response.success && response.data != null) {
        _users = response.data!.items;
      } else {
        // 处理错误
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message ?? '获取用户列表失败')));
      }
    });
  }

  // 显示用户操作弹窗
  void _showUserActions(AdminUserResponse user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('操作用户: ${user.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('邮箱: ${user.email}'),
              Text('状态: ${user.isBlocked ? '已封禁' : '正常'}'),
              Text('角色: ${user.isAdmin ? '管理员' : '普通用户'}'),
            ],
          ),
          actions: [
            // 封禁/解封用户
            if (!user.isBlocked)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showHandleUserDialog(user, true);
                },
                child: const Text('封禁用户'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            if (user.isBlocked)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showHandleUserDialog(user, false);
                },
                child: const Text('解封用户'),
                style: TextButton.styleFrom(foregroundColor: Colors.green),
              ),

            // 设置管理员/取消管理员
            if (!user.isAdmin)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _setAdmin(user.id, true);
                },
                child: const Text('设置为管理员'),
              ),
            if (user.isAdmin)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _setAdmin(user.id, false);
                },
                child: const Text('取消管理员权限'),
              ),

            // 取消
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  // 显示处理用户对话框（封禁/解封）
  void _showHandleUserDialog(AdminUserResponse user, bool isBlocked) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBlocked ? '封禁用户' : '解封用户'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isBlocked ? '请输入封禁原因:' : '请输入解封原因:'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入原因',
                ),
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
            TextButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('请输入处理原因')));
                  return;
                }
                Navigator.pop(context);
                _handleUserStatus(user, isBlocked, reason);
              },
              child: Text(isBlocked ? '封禁' : '解封'),
              style: TextButton.styleFrom(
                foregroundColor: isBlocked ? Colors.red : Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  // 设置/取消管理员权限
  Future<void> _setAdmin(int userId, bool isAdmin) async {
    setState(() {
      _isLoading = true;
    });

    final response = await adminService.setAdmin(
      userId: userId,
      isAdmin: isAdmin,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdmin ? '已设置为管理员' : '已取消管理员权限'),
          backgroundColor: Colors.green,
        ),
      );
      // 重新获取用户列表
      _fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('设置管理员权限失败: ${response.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 处理用户状态（封禁/解封）
  Future<void> _handleUserStatus(
    AdminUserResponse user,
    bool isBlocked,
    String reason,
  ) async {
    setState(() {
      _isLoading = true;
    });

    final response = await adminService.handleUserStatus(
      userId: user.id,
      isBlocked: isBlocked,
      handleReason: reason,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      // 操作成功，刷新用户列表
      _fetchUsers();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(isBlocked ? '用户已封禁' : '用户已解封')));
    } else {
      // 操作失败
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message ?? '操作失败')));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 搜索框
          TextField(
            decoration: InputDecoration(
              labelText: '搜索用户',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _currentPage = 1;
                        });
                        _fetchUsers();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onSubmitted: (value) {
              setState(() {
                _currentPage = 1;
              });
              _fetchUsers();
            },
          ),
          const SizedBox(height: 16),

          // 筛选器
          Row(
            children: [
              const Text('状态筛选: '),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('全部'),
                selected: _isBlockedFilter == null,
                onSelected: (selected) {
                  setState(() {
                    _isBlockedFilter = null;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('已封禁'),
                selected: _isBlockedFilter == true,
                onSelected: (selected) {
                  setState(() {
                    _isBlockedFilter = true;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('正常'),
                selected: _isBlockedFilter == false,
                onSelected: (selected) {
                  setState(() {
                    _isBlockedFilter = false;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text('角色筛选: '),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('全部'),
                selected: _isAdminFilter == null,
                onSelected: (selected) {
                  setState(() {
                    _isAdminFilter = null;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('管理员'),
                selected: _isAdminFilter == true,
                onSelected: (selected) {
                  setState(() {
                    _isAdminFilter = true;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('普通用户'),
                selected: _isAdminFilter == false,
                onSelected: (selected) {
                  setState(() {
                    _isAdminFilter = false;
                    _currentPage = 1;
                  });
                  _fetchUsers();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 用户列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // 头像
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    user.avatar != null &&
                                        user.avatar!.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        imageService.getImageUrl(user.avatar!),
                                      )
                                    : const AssetImage(
                                            'assets/images/avatar.png',
                                          )
                                          as ImageProvider,
                              ),
                              const SizedBox(width: 16),

                              // 用户信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (user.isAdmin) AdminIdentifier(),
                                      ],
                                    ),
                                    Text(user.email),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.isBlocked ? '状态: 已封禁' : '状态: 正常',
                                      style: TextStyle(
                                        color: user.isBlocked
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 操作按钮
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // 用户操作弹窗将在这里添加
                                  _showUserActions(user);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
