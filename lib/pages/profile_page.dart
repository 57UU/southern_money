import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/admin_page.dart';
import 'package:southern_money/pages/my_posts.dart';
import 'package:southern_money/pages/profile_edit_page.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/api_user.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart'
    show ApiResponse, UserProfileResponse;
import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/router_utils.dart';
import '../widgets/profile_menu_item.dart';
import 'my_collection.dart';
import 'my_message.dart';
import 'my_selections.dart';
import 'my_transaction.dart';
import 'setting.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final userService = getIt<ApiUserService>();
  final imageService = getIt<ApiImageService>();
  ApiResponse<UserProfileResponse>? userProfileResponse;

  void loadUserProfile() async {
    userProfileResponse = await userService.getUserProfile();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以使 AutomaticKeepAliveClientMixin 生效
    final body = Builder(
      builder: (context) {
        if (userProfileResponse == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (userProfileResponse!.success == false) {
          return Column(
            spacing: 16,
            children: [
              Text(
                "Failed:${userProfileResponse!.message}",
                style: TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () {
                  loadUserProfile();
                },
                child: const Text("重新加载"),
              ),
              ProfileMenuItem(
                title: '设置',
                icon: Icons.settings,
                onTap: () {
                  popupOrNavigate(context, const Setting());
                },
              ),
            ],
          );
        } else {
          final data = userProfileResponse!.data!;
          final imgUrl = imageService.getImageUrl(data.avatar);
          //ok
          return Column(
            children: [
              // 用户信息卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(imgUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (data.isAdmin) AdminIdentifier(),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${data.id}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            popupOrNavigate(
                              context,
                              ProfileEditPage(
                                userProfileResponse: data,
                                onUpdateSuccess: () {
                                  setState(() {
                                    loadUserProfile();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 资产概览
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '资产概览',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAssetItem(
                            '总资产',
                            '¥${data.asset.total}',
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildAssetItem(
                            '今日收益',
                            '+¥${data.asset.todayEarn}',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAssetItem(
                            '累计收益',
                            '+¥${data.asset.accumulatedEarn}',
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildAssetItem(
                            '收益率',
                            '+${data.asset.earnRate}%',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 功能菜单
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Theme.of(context).cardColor)],
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      title: '交易记录',
                      icon: Icons.history,
                      onTap: () {
                        popupOrNavigate(context, const MyTransaction());
                      },
                    ),
                    ProfileMenuItem(
                      title: '我的自选',
                      icon: Icons.auto_graph,
                      onTap: () {
                        popupOrNavigate(context, const MySelections());
                      },
                    ),
                    ProfileMenuItem(
                      title: '我的收藏',
                      icon: Icons.bookmark_border,
                      onTap: () {
                        popupOrNavigate(context, const MyCollection());
                      },
                    ),
                    ProfileMenuItem(
                      title: '消息通知',
                      icon: Icons.notifications_none,
                      onTap: () {
                        popupOrNavigate(context, const MyMessage());
                      },
                    ),
                    ProfileMenuItem(
                      title: '我的帖子',
                      icon: Icons.post_add,
                      onTap: () {
                        popupOrNavigate(context, const MyPosts());
                      },
                    ),
                    ProfileMenuItem(
                      title: '设置',
                      icon: Icons.settings,
                      onTap: () {
                        popupOrNavigate(context, const Setting());
                      },
                    ),
                    if (data.isAdmin)
                      ProfileMenuItem(
                        title: '管理员中心',
                        icon: Icons.admin_panel_settings,
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AdminPage(),
                            ),
                          );
                        },
                      ),
                    ProfileMenuItem(
                      title: '退出登录',
                      icon: Icons.logout,
                      onTap: () async {
                        final confirm = await showYesNoDialog(
                          context: context,
                          title: '确认退出',
                          content: '您确定要退出登录吗？',
                        );
                        if (confirm == true) {
                          //退出登录
                          appConfigService.tokenService.clearTokens();
                        }
                      },
                      foreColor: Colors.red.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              userProfileResponse = null;
              loadUserProfile();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(child: body),
    );
  }

  Widget _buildAssetItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
