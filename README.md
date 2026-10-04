# survival-kit

## 개요

Claude Code 플러그인이며 기능이 세 가지다.

- 알림 소리: 작업 완료, 승인 요청, API 오류로 멈춤 때 서로 다른 짧은 소리를 낸다.
- `/survival-kit:today`: 생각나는 대로 적은 할 일을 우선순위와 예상 시간이 붙은 표로 정리한다.
- `/survival-kit:morning-news`: AI·경제·비영리 세 분야의 최근 이틀 뉴스를 세 줄로 브리핑한다.

## 설치

로컬에서 시험할 때는 플러그인 폴더를 지정해 Claude Code를 실행한다.

```
claude --plugin-dir /path/to/survival-kit
```

## 알림 소리

| 이벤트 | 훅 | macOS 소리 | Windows 소리 |
|---|---|---|---|
| 작업 완료 | Stop | Tink (0.56초) | 880Hz 0.12초 + 1175Hz 0.16초 |
| 승인 요청 | Notification(permission_prompt) | Morse (0.70초) | 988Hz 0.25초 |
| API 오류로 멈춤 | StopFailure | Frog (0.72초) | 220Hz 0.45초 |

macOS 소리는 원래 길이가 모두 0.8초 미만이라 끝까지 재생된다(`-t 0.8`은 안전장치로 남겨 둠). 훅은 백그라운드(`async`)로 돌아서 소리를 내는 동안 Claude 작업이 멈추지 않는다.

도구 실행 실패(PostToolUseFailure)에는 소리를 내지 않는다. Claude가 스스로 고쳐 가는 경우가 많아 소리가 너무 잦아지기 때문이다.

## 요구 사항

- macOS: 추가 설치 없음.
- Windows: Git Bash가 필요하다. Git Bash가 없으면 Claude Code가 훅을 PowerShell로 실행하므로 `bash` 명령을 찾지 못해 소리가 나지 않고 훅 오류 메시지가 뜰 수 있다.
- Linux(WSL 포함): 소리 없이 넘어간다.

## 소리 끄기

Claude Code를 실행하는 셸에 환경 변수를 설정한다.

```
export SURVIVAL_KIT_SOUND=off
```

## today 사용법

```
/survival-kit:today 6시간 보고서 초안, 김 과장 메일 답장, ...
```

슬래시 명령 없이 "오늘 할 일 정리해줘"처럼 말해도 된다. 맨 앞에 가용 시간(`6시간`, `90분`)을 적거나 "오늘 4시간 있어"처럼 말하면 그 시간 안에 못 들어가는 항목을 "내일로 미룰 것"으로 나눠 준다.

## morning-news 사용법

```
/survival-kit:morning-news
```

"아침 뉴스 브리핑해줘"처럼 말해도 된다. 스킬이 `news-collector` 서브에이전트(`agents/news-collector.md`)를 분야마다 하나씩, 세 개를 동시에 띄운다. 각 서브에이전트는 WebSearch로 어제·오늘 기사를 찾아 3건 이내로 돌려주고, 스킬이 분야마다 한 줄씩 합친다. 분야를 바꾸려면 `skills/morning-news/SKILL.md`의 분야 목록을 고친다.
