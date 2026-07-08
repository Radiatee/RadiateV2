local AvatarEmotesGroup = Tabs.Avatar:AddLeftGroupbox("Emotes", "smile")
local AvatarAnimationsGroup = Tabs.Avatar:AddRightGroupbox("Animations", "person-standing")

local animationSlots = { "idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }
local emoteSlots = { "slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8" }

local AnimationPresets = {
	["Cartoony Animation Package"] = {
		run = "10921076136", walk = "10921082452", fall = "10921077030", jump = "10921078135",
		idle = "10921071918,10921072875", swim = "10921079380", swimidle = "10921081059", climb = "10921070953",
	},
	["Ninja Animation Package"] = {
		run = "10921157929", walk = "10921162768", fall = "10921159222", jump = "10921160088",
		idle = "10921155160,10921155867", swim = "10921161002", swimidle = "10922757002", climb = "10921154678",
	},
	["Vampire Animation Pack"] = {
		run = "10921320299", walk = "10921326949", fall = "10921321317", jump = "10921322186",
		idle = "10921315373,10921316709", swim = "10921324408", swimidle = "10921325443", climb = "10921314188",
	},
	["Toy Animation Pack"] = {
		run = "10921306285", walk = "10921312010", fall = "10921307241", jump = "10921308158",
		idle = "10921301576,10921302207", swim = "10921309319", swimidle = "10921310341", climb = "10921300839",
	},
	["Oldschool Animation Pack"] = {
		run = "10921240218", walk = "10921244891", fall = "10921241244", jump = "10921242013",
		idle = "10921230744,10921232093", swim = "10921243048", swimidle = "10921244018", climb = "10921229866",
	},
}

local MotionaAnimationStorage = {
			["Catwalk Glam Animation"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=119377220967554",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=92294537340807",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=116936326516985",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=81024476153754",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=94970088341563",
					Animation1 = "http://www.roblox.com/asset/?id=133806214992291",
				},
				pose = {
					StylishPose = "http://www.roblox.com/asset/?id=87105332133518",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=134591743181628",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=98854111361360",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=109168724482748",
				},
			},
			["Stylized-Female Animation"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=4708184253",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=4708186162",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=4708192150",
					Animation1 = "http://www.roblox.com/asset/?id=4708191566",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=4708188025",
				},
				run = {
					run = "http://www.roblox.com/asset/?id=4708192705",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=4708189360",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=4708190607",
				},
				walk = {
					walk = "http://www.roblox.com/asset/?id=4708193840",
				},
			},
			["Cowboy Animation Pack"] = {
				walk = {
					RunAnim = "rbxassetid://1014401683",
				},
				swimidle = {
					SwimIdle = "rbxassetid://1014411816",
				},
				swim = {
					Swim = "rbxassetid://1014406523",
				},
				run = {
					RunAnim = "rbxassetid://1014401683",
				},
				jump = {
					JumpAnim = "rbxassetid://1014394726",
				},
				idle = {
					Animation2 = "rbxassetid://1014398616",
					Animation1 = "rbxassetid://1014390418",
				},
				fall = {
					FallAnim = "rbxassetid://1014384571",
				},
				climb = {
					ClimbAnim = "rbxassetid://1014380606",
				},
			},
			["Princess Animation Pack"] = {
				climb = {
					ClimbAnim = "rbxassetid://940996062",
				},
				fall = {
					FallAnim = "rbxassetid://941000007",
				},
				idle = {
					Animation2 = "rbxassetid://941013098",
					Animation1 = "rbxassetid://941003647",
				},
				jump = {
					JumpAnim = "rbxassetid://941008832",
				},
				run = {
					RunAnim = "rbxassetid://941015281",
				},
				swim = {
					Swim = "rbxassetid://941018893",
				},
				swimidle = {
					SwimIdle = "rbxassetid://941025398",
				},
				walk = {
					RunAnim = "rbxassetid://941015281",
				},
			},
			["Sneaky Animation Pack"] = {
				climb = {
					ClimbAnim = "rbxassetid://1132461372",
				},
				fall = {
					FallAnim = "rbxassetid://1132469004",
				},
				idle = {
					Animation2 = "rbxassetid://1132477671",
					Animation1 = "rbxassetid://1132473842",
				},
				jump = {
					JumpAnim = "rbxassetid://1132489853",
				},
				run = {
					RunAnim = "rbxassetid://1132494274",
				},
				swim = {
					Swim = "rbxassetid://1132500520",
				},
				swimidle = {
					SwimIdle = "rbxassetid://1132506407",
				},
				walk = {
					RunAnim = "rbxassetid://1132494274",
				},
			},
			["Patrol Animation Pack"] = {
				climb = {
					ClimbAnim = "rbxassetid://1148811837",
				},
				fall = {
					FallAnim = "rbxassetid://1148863382",
				},
				idle = {
					Animation2 = "rbxassetid://1150842221",
					Animation1 = "rbxassetid://1149612882",
				},
				jump = {
					JumpAnim = "rbxassetid://1150944216",
				},
				run = {
					RunAnim = "rbxassetid://1150967949",
				},
				swim = {
					Swim = "rbxassetid://1151204998",
				},
				swimidle = {
					SwimIdle = "rbxassetid://1151221899",
				},
				walk = {
					RunAnim = "rbxassetid://1150967949",
				},
			},
			["Popstar Animation Pack"] = {
				climb = {
					ClimbAnim = "rbxassetid://1148811837",
				},
				fall = {
					FallAnim = "rbxassetid://1212900995",
				},
				idle = {
					Animation2 = "rbxassetid://1212954651",
					Animation1 = "rbxassetid://1212900985",
				},
				jump = {
					JumpAnim = "rbxassetid://1212954642",
				},
				run = {
					RunAnim = "rbxassetid://1212980348",
				},
				swim = {
					Swim = "rbxassetid://1212852603",
				},
				swimidle = {
					SwimIdle = "rbxassetid://1151221899",
				},
				walk = {
					RunAnim = "rbxassetid://1212980348",
				},
			},
			["Confident Animtion Pack"] = {
				climb = {
					ClimbAnim = "rbxassetid://1069946257",
				},
				fall = {
					FallAnim = "rbxassetid://1069973677",
				},
				idle = {
					Animation2 = "rbxassetid://1069987858",
					Animation1 = "rbxassetid://1069977950",
				},
				jump = {
					JumpAnim = "rbxassetid://1069984524",
				},
				run = {
					RunAnim = "rbxassetid://1070001516",
				},
				swim = {
					Swim = "rbxassetid://1070009914",
				},
				swimidle = {
					SwimIdle = "rbxassetid://1070012133",
				},
				walk = {
					RunAnim = "rbxassetid://1070001516",
				},
			},
			["Realistic Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=11600205519",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=11600206437",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=17173014241",
					Animation1 = "http://www.roblox.com/asset/?id=17172918855",
				},
				pose = {
					RthroIdlePose = "rbxassetid://11600209531",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=11600210487",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=11600211410",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=11600212676",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=11600213505",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=11600249883",
				},
			},
			["Mr.Toilet Animation"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921257536",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921262864",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921263860",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921264784",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921265698",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921269718",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=4417978624",
					Animation1 = "http://www.roblox.com/asset/?id=4417977954",
				},
				pose = {
					Animation = "http://www.roblox.com/asset/?id=4441285342 ",
				},
				run = {
					Animation = "http://www.roblox.com/asset/?id=4417979645",
				},
			},
			["Ud'zal Animation Package"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921257536",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921262864",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921263860",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921264784",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921265698",
				},
				idle = {
					Animation2 = "rbxassetid://3303162549",
					Animation1 = "rbxassetid://3303162274",
				},
				pose = {
					BorockPose = "rbxassetid://3710161342",
				},
				walk = {
					walk = "http://www.roblox.com/asset/?id=3303162967",
				},
				run = {
					run = "http://www.roblox.com/asset/?id=3236836670",
				},
			},
			["NFL Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=134630013742019",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=129773241321032",
				},
				idle = {
					Animation1 = "http://www.roblox.com/asset/?id=92080889861410",
					Animation2 = "http://www.roblox.com/asset/?id=74451233229259",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=119846112151352",
				},
				run = {
					run = "http://www.roblox.com/asset/?id=117333533048078",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=132697394189921",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=79090109939093",
				},
				walk = {
					walk = "http://www.roblox.com/asset/?id=110358958299415",
				},
			},
			["Knight Animation Package"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921121197",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921127095",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921122579",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921123517",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921118894",
					Animation1 = "http://www.roblox.com/asset/?id=10921117521",
				},
				pose = {
					pose = "http://www.roblox.com/asset/?id=10921119700",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921125160",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921125935",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921116196",
				},
			},
			["Zombie Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921343576",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921350320",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921345304",
					Animation1 = "http://www.roblox.com/asset/?id=10921344533",
				},
				pose = {
					ZombiePose = "http://www.roblox.com/asset/?id=10921347258",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921351278",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=616163682",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921352344",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921353442",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921355261",
				},
			},
			["Stylish Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921271391",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921278648",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921273958",
					Animation1 = "http://www.roblox.com/asset/?id=10921272275",
				},
				pose = {
					StylishPose = "http://www.roblox.com/asset/?id=10921275151",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921279832",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921276116",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921281000",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921281964",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921283326",
				},
			},
			["adidas Sports Animation"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=18537384940",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=18537392113",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=18537371272",
					Animation1 = "http://www.roblox.com/asset/?id=18537376492",
				},
				pose = {
					StylishPose = "http://www.roblox.com/asset/?id=18537374150",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=18537380791",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=18537389531",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=18537387180",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=18537367238",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=18537363391",
				},
			},
			["Superhero Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921286911",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921293373",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921290167",
					Animation1 = "http://www.roblox.com/asset/?id=10921288909",
				},
				pose = {
					SuperheroPose = "http://www.roblox.com/asset/?id=10921290942",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921294559",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921291831",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921295495",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921297391",
				},
				walk = {
					RunAnim = "http://www.roblox.com/asset/?id=10921298616",
				},
			},
			["Toy Animation Pack"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921306285",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921312010",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921307241",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921308158",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921302207",
					Animation1 = "http://www.roblox.com/asset/?id=10921301576",
				},
				pose = {
					ToyPose = "http://www.roblox.com/asset/?id=10921303913",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921309319",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921310341",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921300839",
				},
			},
			["Cartoony Animation Package"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921076136",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921082452",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921077030",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921078135",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921072875",
					Animation1 = "http://www.roblox.com/asset/?id=10921071918",
				},
				pose = {
					CartoonyPose = "http://www.roblox.com/asset/?id=10921074502",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921079380",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921081059",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921070953",
				},
			},
			["Levitation Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921132092",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921136539",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921133721",
					Animation1 = "http://www.roblox.com/asset/?id=10921132962",
				},
				pose = {
					LevitationPose = "http://www.roblox.com/asset/?id=10921134514",
				},
				jump = {
					jump = "http://www.roblox.com/asset/?id=10921137402",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921135644",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921138209",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921139478",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921140719",
				},
			},
			["Vampire Animation Pack"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921320299",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921326949",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921321317",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921322186",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921316709",
					Animation1 = "http://www.roblox.com/asset/?id=10921315373",
				},
				pose = {
					PoseAnim = "http://www.roblox.com/asset/?id=10921317792",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921324408",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921325443",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921314188",
				},
			},
			["Elder Animation Package"] = {
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921111375",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921105765",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921107367",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921102574",
					Animation1 = "http://www.roblox.com/asset/?id=10921101664",
				},
				pose = {
					ElderPose = "http://www.roblox.com/asset/?id=10921103538",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921108971",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921110146",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921100400",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921104374",
				},
			},
			["Ninja Animation Package"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921157929",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921162768",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921159222",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921160088",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921155867",
					Animation1 = "http://www.roblox.com/asset/?id=10921155160",
				},
				pose = {
					NinjaPose = "http://www.roblox.com/asset/?id=10921156883",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921161002",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10922757002",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921154678",
				},
			},
			["Oldschool Animation Pack"] = {
				run = {
					run = "http://www.roblox.com/asset/?id=10921240218",
				},
				walk = {
					walk = "http://www.roblox.com/asset/?id=10921244891",
				},
				fall = {
					fall = "http://www.roblox.com/asset/?id=10921241244",
				},
				jump = {
					jump = "http://www.roblox.com/asset/?id=10921242013",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921232093",
					Animation1 = "http://www.roblox.com/asset/?id=10921230744",
				},
				pose = {
					Animation = "http://www.roblox.com/asset/?id=10921233298",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921243048",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921244018",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921229866",
				},
			},
			["Mage Animation Package"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921148209",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921152678",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921148939",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921149743",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921145797",
					Animation1 = "http://www.roblox.com/asset/?id=10921144709",
				},
				pose = {
					MagePose = "http://www.roblox.com/asset/?id=10921146941",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921150788",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921151661",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921143404",
				},
			},
			["Wicked Popular Animation"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=131326830509784",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=121152442762481",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=104325245285198",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=76049494037641",
					Animation1 = "http://www.roblox.com/asset/?id=118832222982049",
				},
				pose = {
					StylishPose = "http://www.roblox.com/asset/?id=138255200176080",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=72301599441680",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=99384245425157",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=113199415118199",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=92072849924640",
				},
			},
			["No-Boundaries Animation"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=18747060903",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=18747062535",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=18747063918",
					Animation1 = "http://www.roblox.com/asset/?id=18747067405",
				},
				pose = {
					Pose = "http://www.roblox.com/asset/?id=18747065848",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=18747069148",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=18747070484",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=18747073181",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=18747071682",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=18747074203",
				},
			},
			["Robot Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921247141",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921251156",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921248831",
					Animation1 = "http://www.roblox.com/asset/?id=10921248039",
				},
				pose = {
					RobotPose = "http://www.roblox.com/asset/?id=10921249579",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921252123",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921250460",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921253142",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921253767",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921255446",
				},
			},
			["Pirate Animation Package"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=750783738",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=750785693",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=750780242",
				},
				jump = {
					jump = "http://www.roblox.com/asset/?id=750782230",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=750782770",
					Animation1 = "http://www.roblox.com/asset/?id=750781874",
				},
				pose = {
					PiratePose = "http://www.roblox.com/asset/?id=885515365",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=750784579",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=750785176",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=750779899",
				},
			},
			["Werewolf Animation Pack"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921336997",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921342074",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921337907",
				},
				jump = {
					jump = "http://www.roblox.com/asset/?id=1083218792",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921333667",
					Animation1 = "http://www.roblox.com/asset/?id=10921330408",
				},
				pose = {
					PoseAnim = "http://www.roblox.com/asset/?id=10921334755",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921340419",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921341319",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921329322",
				},
			},
			["Astronaut Animation Pack"] = {
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921039308",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921046031",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921040576",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921042494",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921036806",
					Animation1 = "http://www.roblox.com/asset/?id=10921034824",
				},
				pose = {
					PoseAnim = "http://www.roblox.com/asset/?id=10921038149",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921044000",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921045006",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921032124",
				},
			},
			["Bold Animation Pack"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=16738332169",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=16738333171",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=16738334710",
					Animation1 = "http://www.roblox.com/asset/?id=16738333868",
				},
				pose = {
					BoldPose = "http://www.roblox.com/asset/?id=16738335517",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=16738336650",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=16738337225",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=16738339158",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=16738339817",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=16738340646",
				},
			},
			["Bubbly Animation Package"] = {
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921063569",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10922582160",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921055107",
					Animation1 = "http://www.roblox.com/asset/?id=10921054344",
				},
				pose = {
					PoseAnim = "http://www.roblox.com/asset/?id=10921056055",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921062673",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921061530",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10980888364",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921057244",
				},
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921053544",
				},
			},
			["Rthro Animation Package"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=10921257536",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=10921262864",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=10921258489",
					Animation1 = "http://www.roblox.com/asset/?id=10921259953",
				},
				pose = {
					RthroIdlePose = "rbxassetid://10921261056",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=10921263860",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=10921261968",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=10921264784",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=10921265698",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=10921269718",
				},
			},
			["Default Animation Package"] = {
				climb = {
					ClimbAnim = "http://www.roblox.com/asset/?id=507765644",
				},
				fall = {
					FallAnim = "http://www.roblox.com/asset/?id=507767968",
				},
				idle = {
					Animation2 = "http://www.roblox.com/asset/?id=507766666",
					Animation1 = "http://www.roblox.com/asset/?id=507766388",
				},
				jump = {
					JumpAnim = "http://www.roblox.com/asset/?id=507765000",
				},
				run = {
					RunAnim = "http://www.roblox.com/asset/?id=913376220",
				},
				swim = {
					Swim = "http://www.roblox.com/asset/?id=913384386",
				},
				swimidle = {
					SwimIdle = "http://www.roblox.com/asset/?id=913389285",
				},
				walk = {
					WalkAnim = "http://www.roblox.com/asset/?id=913402848",
				},
			},
		}

local MotionaEmoteStorage = {
			["Salute"] = {10714389988, 3360689775},
			["Applaud"] = {10713966026, 5915779043},
			["Tilt"] = {10714338461, 3360692915},
			["Shrug"] = {10714374484, 3576968026},
			["Stadium"] = {10714356920, 3360686498},
			["Hello"] = {10714359093, 3576686446},
			["Point2"] = {10714395441, 3576823880},
			["Monkey"] = {10714388352, 3716636630},
			["Curtsy"] = {10714061912, 4646306583},
			["Happy"] = {10714352626, 4849499887},
			["Hype Dance"] = {10714369624, 3696757129},
			["Sleep"] = {10714360343, 4689362868},
			["Shy"] = {10714369325, 3576717965},
			["Floss Dance"] = {10714340543, 5917570207},
			["KATSEYE - Touch"] = {135876612109535, 139021427684680},
			["Baby Queen - Bouncy Twirl"] = {14352343065, 14353423348},
			["Yungblud Happier Jump"] = {15609995579, 15610015346},
			["Baby Queen - Face Frame"] = {14352340648, 14353421343},
			["Chappell Roan HOT TO GO!"] = {85267023718407, 79312439851071},
	["Baby Queen - Strut"] = {14352362059, 14353425085},
	["Godlike"] = {10714347256, 3823158750},
	["Mae Stephens - Piano Hands"] = {16553163212, 16553249658},
	["Alo Yoga Pose - Lotus Position"] = {12507085924, 12507097350},
	["d4vd - Backflip"] = {15693621070, 15694504637},
	["Skibidi Toilet - Titan Speakerman Laser Spin"] = {134283166482394, 103102322875221},
	["Elton John - Heart Shuffle"] = {17748314784, 17748346932},
	["Cuco - Levitate"] = {15698404340, 15698511500},
	["Hero Landing"] = {10714360164, 5104377791},
	["Cha-Cha"] = {10714018192, 3696764866},
	["Air Guitar"] = {10713959108, 3696761354},
	["Quiet Waves"] = {10714390497, 7466046574},
	["BURBERRY LOLA ATTITUDE - HYDRO"] = {10147823318, 10147926081},
	["BURBERRY LOLA ATTITUDE - BLOOM"] = {10714007154, 10147919199},
	["Superhero Reveal"] = {10714355069, 3696759798},
	["Heisman Pose"] = {10714357129, 3696763549},
	["High Wave"] = {10714362852, 5915776835},
	["BURBERRY LOLA ATTITUDE - REFLEX"] = {10714010337, 10147921916},
	["BURBERRY LOLA ATTITUDE - NIMBUS"] = {10147821284, 10147924028},
	["Bored"] = {10713992055, 5230661597},
	["Elton John - Heart Skip"] = {11309255148, 11309263077},
	["Cower"] = {4940563117, 4940597758},
	["Baby Dance"] = {10713983178, 4272484885},
	["BURBERRY LOLA ATTITUDE - GEM"] = {10714008655, 10147916560},
	["Celebrate"] = {10714016223, 3994127840},
	["V Pose - Tommy Hilfiger"] = {10214319518, 10214418283},
	["Frosty Flair - Tommy Hilfiger"] = {10214311282, 10214406616},
	["BLACKPINK Pink Venom - Get em Get em Get em"] = {14548619594, 14548709888},
	["Haha"] = {10714350889, 4102315500},
	["Greatest"] = {10714349037, 3762654854},
	["Line Dance"] = {10714383856, 4049646104},
	["Elton John - Rock Out"] = {11753474067, 11753545334},
	["Old Town Road Dance - Lil Nas X (LNX)"] = {10714391240, 5938394742},
	["Show Dem Wrists - KSI"] = {10714377090, 7202898984},
	["Confused"] = {4940561610, 4940592718},
	["Sad"] = {10714392876, 4849502101},
	["The Zabb"] = {129470135909814, 71389516735424},
	["Mae Stephens – Arm Wave"] = {16584481352, 16584496781},
	["TMNT Dance"] = {18665811005, 18665886405},
	["Team USA Breaking Emote"] = {18526288497, 18526338976},
}
