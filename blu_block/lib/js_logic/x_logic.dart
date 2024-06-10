import 'package:BluBlock/helpers/random_wait_time.dart';

String xBlockLogic = '''
function executeBlock(){
    var result = "BluBlockScriptResult - ";
    try{
    setTimeout(() => {
        const alreadyBlocked = document.getElementsByClassName('css-175oi2r r-sdzlij r-1phboty r-rs99b7 r-lrvibr r-2yi16 r-1qi8awa r-3pj75a r-1loqt21 r-o7ynqc r-6416eg r-1ny4l3l')[0];
        if (alreadyBlocked.dataset.testid.endsWith("unblock")){
            result += 'true';
            console.log(result);
        } else {
            const options_btn = document.getElementsByClassName('css-175oi2r r-sdzlij r-1phboty r-rs99b7 r-lrvibr r-6gpygo r-1wron08 r-2yi16 r-1qi8awa r-1loqt21 r-o7ynqc r-6416eg r-1ny4l3l');
            try{
                options_btn[0].click()
                setTimeout(() => {
                    try{
                        const block_btns = document.getElementsByClassName('css-175oi2r r-1loqt21 r-18u37iz r-1mmae3n r-3pj75a r-13qz1uu r-o7ynqc r-6416eg r-1ny4l3l');
                        const block_btn = block_btns[6];
                        try{
                            block_btn.click();
                            setTimeout(() => {
                                const block_executors = document.getElementsByClassName ('css-175oi2r r-sdzlij r-1phboty r-rs99b7 r-lrvibr r-16y2uox r-6gpygo r-1udh08x r-1udbk01 r-3s2u2q r-peo1c r-1ps3wis r-cxgwc0 r-1loqt21 r-o7ynqc r-6416eg r-1ny4l3l');
                                const block_executor = block_executors[0];
                                block_executor.click()
                                result += 'true';
                                console.log(result);
                                },${randomNumberGenerator(250, 750)});
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
                },${randomNumberGenerator(250, 500)});
            } catch {
                result += 'false';
                console.log("Error while clicking options_btn");
                console.log(result);
            }
        }
    },${randomNumberGenerator(250, 1000)});
    } catch {
    result += 'false';
    console.log(result);
    }
}

window.onload = executeBlock();
''';

String xLoginLogic='''
function checkLogin() {
    var result = "BluBlockScriptResult - ";
    setTimeout(() => {
        const loginBtn = document.getElementsByClassName("css-175oi2r r-sdzlij r-1phboty r-rs99b7 r-lrvibr r-a9p05 r-1a8msfu r-5oul0u r-1ipicw7 r-1ii58gl r-25kp3t r-ubg91z r-o7ynqc r-6416eg r-1ny4l3l r-1loqt21")[0]
        try {
            if (loginBtn.href.endsWith("/i/flow/signup")){
                result += 'false';
            } else {
                result += 'true';
            }
        } catch {
            result += 'true';
            console.log(result);
        }
        console.log(result);
    },${randomNumberGenerator(250, 1000)});
}

window.onload = checkLogin();
''';