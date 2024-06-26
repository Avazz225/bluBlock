import 'package:BluBlock/helpers/random_wait_time.dart';

String tiktokBlockLogic = '''
function executeBlock(){
  var result = "BluBlockScriptResult - ";
  console.log("EXECUTING...");
  try{
    setTimeout(() => {
      const options_btn = document.getElementsByClassName("css-usq6rj-DivMoreActions ee7zj8d10");
      try{
        options_btn[0].dispatchEvent(new KeyboardEvent('keydown', {
          bubbles: true, cancelable: true, keyCode: 13
        }))
        setTimeout(() => {
          try{
            const block_btn = document.getElementsByClassName('css-15eaot2-DivActionContainer e1vhy9gd1');
            console.log(block_btn[0])
            var text = block_btn[2].ariaLabel.toLowerCase();
            if (text === "sperren" || text === "block"){
              try{
                block_btn.click();
                setTimeout(() => {
                  const block_executors = document.getElementsByClassName ('e9flc1l5 css-nuawxs-Button-StyledButtonBlock ehk74z00');
                  var block_executor = block_executors[0];
                  block_executor.click()
                  result += 'true';
                  console.log(result);
                  },${randomNumberGenerator(250, 500)});
              } catch {
                result += 'false';
                console.log("Error while clicking block_executor");
                console.log(result);
              }
            } else {
              result += 'true';
              console.log(result);
            }
          } catch {
            result += 'false';
            console.log("Error while clicking block_btn");
            console.log(result);
          }
        },${randomNumberGenerator(1200, 1550)});
      } catch {
        result += 'false';
        console.log("Error while clicking options_btn");
        console.log(result);
      }
    },${randomNumberGenerator(1000, 1500)});
  } catch {
    result += 'false';
    console.log(result);
  }
}


window.onload = executeBlock();
''';

String tiktokLoginLogic = '''
function checkLogin() {
  var result = "BluBlockScriptResult - ";
  try {
    setTimeout(() => {
      const loginBtn = document.getElementById('header-login-button');
      if (loginBtn) {
          result += 'false';
          console.log(result);
      } else {
        setTimeout(() => {
          const registerLink = document.getElementsByClassName('css-12ys7l-ALink epl6mg0')[0];
          if (registerLink){
            if (registerLink.href === "https://www.tiktok.com/signup"){
              result += 'false'
              console.log(result);
            } else {
                result += 'true';
                console.log(result);
            }
          } else {
            result += 'true';
            console.log(result);
          }
        },${randomNumberGenerator(1000, 1250)}); 
      }
    },${randomNumberGenerator(1000, 1250)});
  } catch {
      result += 'false';
      console.log(result);
  }
}

window.onload = checkLogin();
''';