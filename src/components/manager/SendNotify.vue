<template>
<div>
<div><H4 style="color:purple;">訊息推播</H4></div>    
<div style="padding: 20px;">
<div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">推播群組<br></span></div>
        <select v-model="currentSendGroup" class="form-control" style="width: 80px">
            <optgroup label="推播群組">
                <Option v-for="item in this.NickInfo" 
                        :value="item.nickName" 
                        :key="item.nickName"
                        >{{ item.relName }}
                </Option>
            </optgroup>
        </select>                                 
    <div class="input-group-append"></div>
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">推播內容<br></span></div>
        <select v-model="currentMessage" class="form-control" style="width: 80px">
            <optgroup label="推播內容">
                <Option v-for="item in this.MessageList" 
                        :value="item.sendContent" 
                        :key="item.sendContent"
                        >{{ item.SendType }}
                </Option>
            </optgroup>
        </select>                 
    <div class="input-group-append"></div>
    <!--div><button v-on:click="SendLineNotify" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px">送出</button></div-->                  
</div>
</div>  
<div ref="divWrapper" style="padding: 30px">
    <form  @submit.prevent="onSubmitAddNews">
        <!-- <form> -->
        <div class="form-group">
            <div margin-left="auto" margin-right="auto">  推播訊息:
                <div>
                    <textarea v-model="currentMessage" 
                    rows="5"
                    :style="{ width: '720px' }"/>
                </div>     
            </div>
            <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                <button  type="button" class="btn btn-primary" style="margin: 5px;" @click="SendLineNotify();">傳送</button>
                <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="CancelAdd();">取消內容</button>
            </div> 
        </div>
    </form>
</div>
<vue-toastr ref="toastr"></vue-toastr>         
</div>
</template>

<style scoped src="../../assets/register/bootstrap/css/register.bootstrap.min.css"></style>
<style scoped src="../../assets/register/css/register.css"></style>
<script src="../../assets/register/js/register.js"></script>
<script>
import axios from 'axios';
import { Grid, GridToolbar, GridNoRecords } from '@progress/kendo-vue-grid';
import Vue from 'vue';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import $ from 'jquery';
import '@progress/kendo-ui'
import '@progress/kendo-theme-default/dist/all.css'
import '@progress/kendo-ui/js/messages/kendo.messages.zh-TW.js'
import { NumericTextBox } from '@progress/kendo-inputs-vue-wrapper';
import edit_remove_duplicate_GiveClass_CommandCell from './CommandCell/edit_remove_duplicate_GiveClass_CommandCell.vue';
Vue.use(VueToast);
Vue.use(axios);
var moment = require('moment');
/* eslint-disable no-debugger, no-console */
export default {
    name:"SendNotify",
    components: {
        'Grid': Grid,
        'grid-toolbar': GridToolbar,
        'custom': edit_remove_duplicate_GiveClass_CommandCell,
    },
    mounted() {   
        this.refreshAll();             
    },    
    data: function () {
        return {
            NickInfo:[],
            MessageList:[
                {
                    SendType:'消防測試中',
                    sendContent:'目前正在進行消防測試'
                },
                {
                    SendType:'消防測試結束',
                    sendContent:'消防測試已經結束'
                },
                {
                    SendType:'警報啟動',
                    sendContent:'保全系統已開啟'
                },
                {
                    SendType:'警聲關閉',
                    sendContent:'消防警聲已經被關閉'
                },
                {
                    SendType:'系統關閉',
                    sendContent:'保全系統已經被關閉'
                },
                {
                    SendType:'系統測試',
                    sendContent:'推播系統發訊測試'
                },
            ],                
            currentMessage:'',

            SendGroupList:[
                {
                    SendGroup:'AA 大樓',
                    sendID:'test1226'
                },
                {
                    SendGroup:'BB 大樓',
                    sendID:'test001'
                },
                {
                    SendGroup:'CC 大樓',
                    sendID:'Alarm has been closed'
                },
                {
                    SendGroup:'DD 大樓',
                    sendID:'EMS Shutdown!'
                },
            ],                
            currentSendGroup:'',

            sendStatus:'Null',
            };
    },
    computed: {
      
    },
    methods: {
         refreshAll(){
            axios.get(Vue.prototype.$httpPath+'/addscriber/getAllNick')
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.NickInfo=response.data;
                        //this.NickInfo.splice(0, 0, "");  
                    }
                })
        },
        CancelAdd(){
            this.currentMessage='';
            this.currentMessage='';
            this.currentSendGroup='';
        },
        SendLineNotify()
        {
            if(this.currentMessage == '' || this.currentMessage == null){
                Vue.$toast.open({
                message: '請輸入訊息。',
                position: 'top',
                type: 'error'
                });
            }
            else{
                Vue.$toast.open({
                        message: '傳送中...',
                        position: 'bottom-right',
                        type: 'success'
                        }); 
                /*('http://35.194.229.108/sendDemo?group='+this.currentSendGroup+'&content='+this.currentMessage)*/

                //const baseURL = 'http://35.194.229.108/sendDemo?group=test1226&content=AAABBBCCC'
                //const baseURL = 'http://35.194.229.108/notifyapi/sendtest'
                //const baseURL = '/notifyapi/sendline'
                axios.get(Vue.prototype.$httpPath+'/notifyapi/sendDemo',{
                            params: {
                                group: this.currentSendGroup,
                                content: this.currentMessage
                            }
                        })
                    .then((response) => {
                        if(response.status==200)
                        {
                        Vue.$toast.open({
                            message: '傳送完成',
                            position: 'bottom-right',
                            type: 'success'
                            });                   
                        }   
                        else
                        {
                            Vue.$toast.open({
                            message: '錯誤001',
                            position: 'top',
                            type: 'error'
                            });   
                        }
                    })
                    .catch((error) => {
                            Vue.$toast.open({
                            message: baseURL,
                            position: 'top',
                            type: 'error'
                            }); 
                            Vue.$toast.open({
                            message: error,
                            position: 'top',
                            type: 'error'
                            });   
                    }).finally(() => {
                }); 
            } 
        },  
        giveClass(dataItem) {
            window.location.href = '/#/GiveClassSys?classCat='+dataItem.classGroup+'&classId='+dataItem.classCode;
        },
        OpenAddNews (event) {
            this.$bvModal.show('bv-modal-add-news');
        }, 
    },
};
</script>
<style>
    @import "../../assets/css/telerik/all.css";
    .k-header {
        font-size: 16px; /* Sets icon size to 32px */
    }   
</style>