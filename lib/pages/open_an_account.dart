import 'package:flutter/material.dart';

class OpenAnAccount extends StatefulWidget {
  const OpenAnAccount({super.key});

  @override
  State<OpenAnAccount> createState() => _OpenAnAccountState();
}

class _OpenAnAccountState extends State<OpenAnAccount> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开户'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '开户协议',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle('1. 服务条款'),
                      _buildSectionContent('欢迎使用南方资金开户服务。在使用本服务前，请仔细阅读以下条款。'),
                      _buildSectionTitle('2. 风险提示'),
                      _buildSectionContent(
                        '投资有风险，入市需谨慎。您应充分了解投资可能存在的风险，并根据自身的风险承受能力做出投资决策。',
                      ),
                      _buildSectionTitle('3. 账户安全'),
                      _buildSectionContent(
                        '请妥善保管您的账户信息和密码，不要将账户信息泄露给他人。如发现账户异常，请及时联系我们。',
                      ),
                      _buildSectionTitle('4. 隐私保护'),
                      _buildSectionContent(
                        '我们重视您的隐私保护，将按照相关法律法规的要求，保护您的个人信息安全。',
                      ),
                      _buildSectionTitle('5. 法律责任'),
                      _buildSectionContent('您应遵守国家法律法规，不得利用本服务从事任何违法违规活动。'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
                const Text('我已阅读并同意以上开户协议'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreedToTerms
                    ? () {
                        _showConfirmationDialog();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('确认开户', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(content, style: TextStyle(fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认开户'),
          content: const Text('您确定要完成开户操作吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessDialog();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('开户成功'),
          content: const Text('恭喜您，账户已成功开通！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
