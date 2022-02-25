<template>
<div>
<div><H4 style="color:purple;">QR Code 產生</H4></div>    
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
    <!--div><button v-on:click="SendLineNotify" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px">送出</button></div-->                  
</div>
</div>  
<div ref="divWrapper" style="padding: 30px">
    <form  @submit.prevent="onSubmitAddNews">
        <!-- <form> -->
        <div class="form-group">
            <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                <button  type="button" class="btn btn-primary" style="margin: 5px;" @click="createLineURL();">查詢 QR Code</button>
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
                    }
                })
        },
        createLineURL(){
            this.$bvModal.hide('bv-modal-add-news');
            this.currentURL = 'http://35.194.229.108/addscriber/reRoute?code='+ this.currentSendGroup
            this.$router.push(
                {
                    path: '/QRcode',
                    query: 
                    {
                        codeUrl: this.currentURL,
                    }
                }
            );
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