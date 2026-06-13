/client/proc/OpenMaturityPrompt()
	var/dat = "<html>"
	dat += {"
	<head>
		<style>
			p {
				text-align: center;
			}
			form {
				width: 300px;
				margin: 0 auto;
				text-align: center;
			}
			input {
				background-color: #0E141B;	
				color: #D0D8DC;		
			}
			.input-row {
				display: inline-block;
				margin-right: 10px;
				vertical-align: top;
			}
			.input-row label {
				display: block;
				margin-bottom: 5px;
			}
			.input-row input {
				width: 80px;
				box-sizing: border-box;
			}
			.button-row {
				text-align: center;
				margin-top: 20px;
			}
		</style>
	</head>
	"}
	dat += "<body>"
	dat += {"
		<p>
			本服务器包含成熟主题内容，包括暴力、复杂的道德困境，以及成人情境。接受并游玩本游戏即表示你已知悉并同意角色在游戏内遭遇的一切后果，同时你也将以善意进行游戏，为他人共同创造精彩故事。请先阅读 Discord 服务器中的规则。
			<br>
			我们只会保留年份与月份，日期会在首次校验后丢弃。
			<br>
			虚假申报将导致你被封禁。
			<br>
		</p>
		<form method='get' action='?src=[REF(src)]'>
			<input type="hidden" name="age_prompt" value="age_prompt">
			<div class="input-row">
				<label for="year">年份</label>
				<input type="number" id="year" name="year" min="1900" max="2100" required>
			</div>
			<div class="input-row">
				<label for="month">月份</label>
				<input type="number" id="month" name="month" min="1" max="12" required>
			</div>
			<div class="input-row">
				<label for="day">日期</label>
				<input type="number" id="day" name="day" min="1" max="31" required>
			</div>
			<div class="button-row">
				<button type="submit">提交</button>
			</div>
		</form>
	"}
	dat += "</body></html>"
	var/datum/browser/popup = new(src, "ageprompt", "请输入你的出生日期", 680, 310)
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/client/proc/CloseMaturityPrompt()
	src << browse(null, "window=ageprompt")
