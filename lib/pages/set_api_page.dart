import 'package:flutter/material.dart';
import 'package:southern_money/pages/theme_color_page.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/definitions_response.dart';
import 'package:southern_money/webapi/test.dart';
import 'package:southern_money/widgets/dialog.dart';

class SetApiUrlPage extends StatefulWidget {
  const SetApiUrlPage({super.key});

  @override
  State<SetApiUrlPage> createState() => _SetApiUrlPageState();
}

class _SetApiUrlPageState extends State<SetApiUrlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置API")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            titleText("Current API:"),
            Text("${baseUrl}"),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _editApiPopup()),
                Expanded(child: _testButton()),
              ],
            ),
            titleText("Quick Set"),
            _buildQuickSet("http://localhost:5062"),
          ],
        ),
      ),
    );
  }

  Widget _editApiPopup() {
    final btn = OutlinedButton(
      onPressed: _displayEditApiPopup,
      child: Text("Edit"),
    );
    return btn;
  }

  void _displayEditApiPopup() {
    final TextEditingController controller = TextEditingController(
      text: baseUrl,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("编辑API"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "输入新的API"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                apiBaseUrl.value = controller.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text("确认"),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSet(String apiUrl) {
    final btn = OutlinedButton(
      onPressed: () {
        setState(() {
          apiBaseUrl.value = apiUrl;
        });
      },
      child: Text(apiUrl),
    );
    return SizedBox(width: double.infinity, child: btn);
  }

  Widget _testButton() {
    return OutlinedButton(onPressed: _testApi, child: Text("Test API"));
  }

  Future _testApi() async {
    ApiResponse<TestResponse>? result;
    await showLoadingDialog(func: () async => result = await testApi());
    bool success = result?.success == true;
    if (success) {
      showInfoDialog(title: 'Success', content: result?.data?.message ?? "");
    } else {
      showInfoDialog(title: 'Error', content: result?.message ?? "");
    }
  }
}
