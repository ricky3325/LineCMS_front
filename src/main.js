import Vue from "vue";
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import axios from "axios";
import VueAxios from "vue-axios";
import App from "./App.vue";
import router from "./router";
import store from "./store";
//import VeeValidate, { validate } from 'vee-validate'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
/*--<驗證設定>--start*/
import { ValidationObserver, ValidationProvider, extend, localize, configure } from 'vee-validate';
import  VeeValidate from 'vee-validate';
import zhTW  from 'vee-validate/dist/locale/zh_TW';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.css';
import axiosSetup from "./helpers/axios.js";
import '@progress/kendo-ui'
import '@progress/kendo-theme-default/dist/all.css'
import { Scheduler } from '@progress/kendo-scheduler-vue-wrapper'
import { SchedulerResource } from '@progress/kendo-scheduler-vue-wrapper'
import { SchedulerView } from '@progress/kendo-scheduler-vue-wrapper'
import { SchedulerInstaller } from '@progress/kendo-scheduler-vue-wrapper'

axiosSetup();
Vue.use(ElementUI);
Vue.component('Loading', Loading);
Vue.use(SchedulerInstaller);
//localize('zh_TW', zhTW)

import VueI18n from 'vue-i18n';
Vue.use(VueI18n);

//Vue.config.productionTip = false;
// Object.keys(rules).forEach((rule) => {
//   extend(rule, rules[rule]);
// });
Vue.use(VueAxios,axios);
axios.defaults.witCredentials = true;
Vue.component('ValidationObserver', ValidationObserver)
/*--<驗證設定>--end*/
//import { required } from "vee-validate/dist/rules";
Vue.use(BootstrapVue);
Vue.use(IconsPlugin);

Vue.prototype.$httpPath = "http://59.127.185.48"

//Vue.prototype.$httpPath = "https://localhost:44344/api"
Vue.prototype.$httpPath_front = "https://localhost";

// Vue.prototype.$httpPath = "https://10.9.200.16:442/api";
// Vue.prototype.$httpPath_front = "https://10.9.200.16";

// Vue.prototype.$httpPath = "https://train.firdi.org.tw:442/api";
// Vue.prototype.$httpPath_front = "https://train.firdi.org.tw";

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");

router.beforeEach((to, from, next) => {
  //console.log('to',to,'from',from,'next',next);
  if (to.meta.requiresAuth) {
    if (localStorage.getItem("access_token") == "") {
      next({
        path: "/login",
        params: { nextUrl: to.fullPath },
      });
    } else {
      if (!localStorage.getItem("isAuthenticated")) {
        next({
          path: "/login",
          params: { nextUrl: to.fullPath },
        });
      } else {
        next();
      }
    }
  } else {
    next();
  }
});