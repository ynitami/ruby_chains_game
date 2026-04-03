import { application } from "controllers/application"

import ChainController from "controllers/chain_controller"
application.register("chain", ChainController)

import CounterController from "controllers/counter_controller"
application.register("counter", CounterController)

import PlayerFormController from "controllers/player_form_controller"
application.register("player-form", PlayerFormController)

import RulesDialogController from "controllers/rules_dialog_controller"
application.register("rules-dialog", RulesDialogController)

import RulesTabController from "controllers/rules_tab_controller"
application.register("rules-tab", RulesTabController)
