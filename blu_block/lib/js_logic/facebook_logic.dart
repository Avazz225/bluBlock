import 'package:BluBlock/helpers/random_wait_time.dart';

String facebookBlockLogic = '''
function executeBlock(){
    var result = "BluBlockScriptResult - ";
    try{
    setTimeout(() => {
        const options_btn = document.querySelector('[data-action-id="32731"]');
        try{
            options_btn.click();
            setTimeout(() => {
                try{
                    const block_btn = document.querySelector('[data-action-id="32759"]');
                    try{
                        block_btn.click();
                        setTimeout(() => {
                            const block_executor = document.querySelector('[data-action-id="32759"]');
                            block_executor.click()
                            result += 'true';
                            console.log(result);
                            },200);
                    } catch {
                        result += 'false';
                        console.log("Error while clicking block_executor");
                        console.log(result);
                    }
                } catch {
                result += 'false';
                console.log("Error while clicking block_btn");
                console.log(result);
                }
            },200);
        } catch {
            console.log("Maybe already blocked");
            const btns = document.getElementsByClassName("m bg-s5")
            if (btns.length == 2){
                result += 'true';
            } else {
                result += 'false';
                console.log("Error while clicking options_btn");
            }
        console.log(result);
        }
    },200);
    } catch {
    result += 'false';
    console.log(result);
    }
}

window.onload = executeBlock();
''';

String facebookLoginLogic = '''
function checkLogin() {
    var result = "BluBlockScriptResult - ";
    setTimeout(() => {
        const loginBtn = document.querySelectorAll('[data-testid="royal_login_button"]')
        try {
            if (loginBtn.length === 1){
                result += 'false';
            } else {
                result += 'true';
            }
        } catch {
            result += 'true';
            console.log(result);
        }
        console.log(result);
    },${randomNumberGenerator(250, 750)});
}

window.onload = checkLogin();
''';