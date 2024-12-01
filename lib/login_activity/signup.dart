import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupController(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('회원가입'),
          backgroundColor: Colors.white,
        ),
        body: Consumer<SignupController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40),
                      Text('회원가입', style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      _buildTextField(controller.nameController, '이름', Icons.person),
                      _buildTextField(controller.usernameController, '아이디', Icons.person_outline),
                      _buildTextField(controller.passwordController, '비밀번호', Icons.lock, obscureText: true),
                      _buildTextField(controller.confirmPasswordController, '비밀번호 확인', Icons.lock_outline, obscureText: true),
                      _buildTextField(controller.phoneNumberController, '전화번호', Icons.phone, keyboardType: TextInputType.phone),
                      _buildTextField(controller.companyController, '회사명', Icons.business),
                      _buildTextField(controller.positionController, '직급', Icons.badge),
                      _buildTextField(controller.teamController, '팀명', Icons.group),
                      if (controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            controller.errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => controller.submitData(context),
                        child: Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF25c387),
                          padding: EdgeInsets.symmetric(vertical: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          floatingLabelStyle: TextStyle(color: Colors.grey),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label을 입력해주세요.';
          }
          return null;
        },
      ),
    );
  }
}
