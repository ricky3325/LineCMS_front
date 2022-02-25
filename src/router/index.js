import Vue from "vue";
import VueRouter from "vue-router";
import layout from "@/components/manager/layout.vue";
import ClassInfo from "@/components/manager/ClassInfo.vue";
import SendNotify from "@/components/manager/SendNotify.vue";
import UnderConstruction from "@/components/UnderConstruction.vue";
import SignUp from "@/components/manager/SignUp.vue";
import AddClient from "@/components/manager/AddClient.vue";
import QRcode from "@/components/manager/QRcode.vue";
import showQR from "@/components/manager/showQR.vue";
import AddSuber from "@/components/manager/AddSuber.vue";
import Login from "@/components/Login.vue";
import '@progress/kendo-ui/js/messages/kendo.messages.zh-TW.js'
Vue.use(VueRouter);

export const routes = [      
  {
    path: '/',
    name: "layout",
    component:layout,
    //meta: { requiresAuth: true},
    children:[   
      {
        path: "/ClassInfo",
        name: "ClassInfo",
        component: ClassInfo,
        meta: { requiresAuth: true},   
      },    
      {
        path: "/SendNotify",
        name: "SendNotify",
        component: SendNotify,
        //meta: { requiresAuth: true},   
      },   
      {
        path: "/AddClient",
        name: "AddClient",
        component: AddClient,
        //meta: { requiresAuth: true},   
      },
      {
        path: "/showQR",
        name: "showQR",
        component: showQR,
        //meta: { requiresAuth: true},   
      },
      //AddSuber
      {
        path: "/AddSuber",
        name: "AddSuber",
        component: AddSuber,
        //meta: { requiresAuth: true},   
      },
      {
        path: "/QRcode",
        name: "QRcode",
        component: QRcode,
        //meta: { requiresAuth: true},   
      },
      ] 
  },           
];

const router = new VueRouter({
  model: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
