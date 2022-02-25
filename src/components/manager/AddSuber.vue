<template>
<div>
<div><H4 style="color:purple;">加入社區</H4></div>    
<div style="padding: 20px;">
</div>  
<div ref="divWrapper" style="padding: 30px">
    <Grid
        ref="grid"
        :style="{height: '500px', width:'100%'}"
        :resizable="true"
        :data-items="ClassInfos"
        :selected-field="selectedField"
        :columns="columns"
        @rowclick="onRowClick"
        :pageable="true"
        :skip= "skip"
        :take="take"
        :total="total"
        @pagechange="pageChangeHandler"
        >      
        <template v-slot:myTemplate="{props}">
            <custom :data-item="props.dataItem" 
                    @duplicate="duplicate"
                    @giveClass="giveClass"
                    @printDoc="printDoc"
                    @edit="edit"
                    @remove="remove"/>
        </template>       
        <grid-toolbar>
            <button title="新增社區"
                    class="k-button k-primary"
                    @click='OpenAddNews' >
                新增社區
            </button>
        </grid-toolbar>      
        <grid-norecords name="classInfo-grid-norecords">
           <div  class="k-loading-mask customPosition"><span class='k-loading-text'></span><div class='k-loading-image'/><div class='k-loading-color'/></div>
        </grid-norecords>            
    </Grid>
</div>
    <div id="containerAddNews" class="modal-dialog modal-lg">
        <b-modal id="bv-modal-add-news" hide-footer  hide-header-close no-close-on-esc no-close-on-backdrop>
            <template #modal-title>
                產生社區Line通知網址
            </template> 
            <form  @submit.prevent="onSubmitAddNews">
            <!-- <form> -->  
                <div class="form-group">
                    <div margin-left="auto" margin-right="auto">
                        <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                            <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                                <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">社區名稱<br></span></div>
                                <input v-model="currentCommunityName" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" required>
                                <div class="input-group-append"></div>
                            </div>
                            <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                                <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">客戶代號<br></span></div>
                                <input v-model="currentCommunityCode" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" required>
                                <div class="input-group-append"></div>
                            </div>
                        </div>
                    </div>
                    <div>
                    </div>
                    <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                        <button type="submit" class="btn btn-primary" style="margin: 5px;" id="send">產生網址</button>
                        <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="$bvModal.hide('bv-modal-add-news');CancelAdd();">關閉</button>
                    </div>
                </div>
            </form>
            <br/>
        </b-modal>
    </div> 
    <div id="containerEditNews" class="modal-dialog modal-lg">
        <b-modal id="bv-modal-edit-news" hide-footer  hide-header-close no-close-on-esc no-close-on-backdrop>
            <template #modal-title>
                編輯社區資訊
            </template> 
            <form  @submit.prevent="onSubmitEditNews">
            <!-- <form> -->  
                <div class="form-group">
                    <div margin-left="auto" margin-right="auto">
                        <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                            <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                                <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">客戶代號<br></span></div>
                                <input v-model="currentCommunityCode" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" readonly>
                                <div class="input-group-append"></div>
                            </div>
                            <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                                <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">社區名稱<br></span></div>
                                <input v-model="currentCommunityName" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" required>
                                <div class="input-group-append"></div>
                            </div>
                        </div>
                    </div>
                    <div>
                    </div>
                    <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                        <button type="submit" class="btn btn-primary" style="margin: 5px;" id="send">儲存</button>
                        <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="$bvModal.hide('bv-modal-edit-news');CancelAdd();">關閉</button>
                    </div>
                </div>
            </form>
            <br/>
        </b-modal>
    </div> 
    <div id="showURL" class="modal-dialog modal-lg">
        <b-modal id="bv-modal-show-url" hide-footer  hide-header-close no-close-on-esc no-close-on-backdrop>
            <template #modal-title>
                {{currentCommunityName}}社區Line通知網址
            </template> 
            <form  @submit.prevent="onSubmitShowUrl">
            <!-- <form> -->  
                <div class="form-group">
                    <div margin-left="auto" margin-right="auto">
                        
                    </div>
                    <!--div>
                            {{currentURL}}
                    </div-->
                    
                    <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                        <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="$bvModal.hide('bv-modal-show-url');CancelAdd();">關閉</button>
                    </div>
                </div>
            </form>
            <br/>
        </b-modal>
    </div> 
    <vue-toastr ref="toastr"></vue-toastr>         
</div>
</template>

<style scoped src="../../assets/register/bootstrap/css/register.bootstrap.min.css"></style>
<style scoped src="../../assets/register/css/register.css"></style>
<script src="../../assets/register/js/register.js"></script>
<script>
import axios from 'axios';
import qs from 'qs'
import { Grid, GridToolbar, GridNoRecords } from '@progress/kendo-vue-grid';
import Vue from 'vue';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import $ from 'jquery';
import '@progress/kendo-ui'
import '@progress/kendo-theme-default/dist/all.css'
import '@progress/kendo-ui/js/messages/kendo.messages.zh-TW.js'
import { NumericTextBox } from '@progress/kendo-inputs-vue-wrapper';
import edit_remove_CommandCell from './CommandCell/edit_remove_CommandCell.vue';
Vue.use(VueToast);
var moment = require('moment');
/* eslint-disable no-debugger, no-console */
export default {
    name:"ClassInfo",
    components: {
        'Grid': Grid,
        'grid-toolbar': GridToolbar,
        'custom': edit_remove_CommandCell,
    },
    mounted() {   
        this.refreshAll();           
    },    
    data: function () {
        return {
            selectedField: 'selected',
            selectedID: 1,
            currentPage:1,
            skip: 0,
            take: 10,     
            ClassInfos:[],       
            guid:'',
            currentCommunityName:'',
            currentURL:'',
            currentCommunityCode:'',
            currentCommunityGuid:'',
            };
    },
    computed: {
      columns() {
          return [
                { cell: 'myTemplate', width: '165px' },
                { hidden: true, field: 'guid', title: 'guid', width: '100px' },
                { field: 'title', title: '客戶代號', width: this.setPercentage(20) },
                { field: 'content', title: 'Token' , width: this.setPercentage(20)},    
          ];
      },        
        items () {
            return this.ClassInfos.map((item) => ({ ...item, selected: item.guid === this.selectedID }));
        },
        selectedItem () {
            return this.ClassInfos.find((item) => item.guid === this.guid);
        },
        result: {
            get: function() {
                return this.ClassInfos.slice(this.skip, this.take + this.skip);
            }
        },    
        total () {
            return this.ClassInfos.totalRows;
        },           
    },
    methods: {
        onRowClick (event) {
            //this.guid = event.dataItem.guid;
            /*Vue.$toast.open({
                message: '編輯訊息:服務維護中',
                position: 'top',
                type: 'success'
                });*/
        }, 
        remove(dataItem) {
            const qs = require('qs');
            axios.post(this.$httpPath+'/addscriber/delOneNick', 
                qs.stringify({
                    _id:dataItem.id,
                    relName:dataItem.relName,
                    nickName:dataItem.nickName
                }),
            )
            .then((response)=>{
                    if(response.status===200)
                    {
                        Vue.$toast.open({
                        message: '刪除成功',
                        position: 'bottom-right',
                        type: 'success'
                        });
                        this.refreshGrid();
                    }
                })
        },
        refreshGrid()
        {
            this.gridWidth = this.$refs.divWrapper.offsetWidth;   
            axios.get(Vue.prototype.$httpPath+'/addscriber/readInfo')
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.ClassInfos=response.data;
                    }
                })
        },  
        refreshAll()
        {
            this.refreshGrid();
        },    
        CancelAdd(){
            this.currentCommunityName = '';
            this.currentURL = '';
            this.currentCommunityCode = '';
            this.currentCommunityGuid = '';
        },            
        setPercentage (percentage) {
            return Math.round(this.gridWidth / 100) * percentage;
        },            
        onSubmitAddNews: async function ()
        {
            Vue.$toast.open({
                        message: '保存中...' + this.currentCommunityName + ': ' + this.currentCommunityCode,
                        position: 'bottom-right',
                        type: 'success'
                        });
            axios.get(Vue.prototype.$httpPath+'/addscriber/addNick',{
                params:{
                    name:this.currentCommunityName,
                    nick:this.currentCommunityCode
                    }
                })
                .then((response)=>{
                    if(response.status===200)
                    {
                        Vue.$toast.open({
                        message: 'QR Code 產生中...' + this.currentCommunityName + ': ' + this.currentCommunityCode,
                        position: 'bottom-right',
                        type: 'success'
                        });
                        this.createLineURL();
                    }
                })
        },
        OpenAddNews (event) {
            this.$bvModal.show('bv-modal-add-news');
        },
        edit(dataItem) {
            this.OpenEditNews();
            this.currentCommunityGuid = dataItem.id;
            this.currentCommunityName = dataItem.relName;
            this.currentCommunityCode = dataItem.nickName;
        },
        OpenEditNews (event) {
            this.$bvModal.show('bv-modal-edit-news');
        },
        CloseEditNews (event) {
            this.$bvModal.hide('bv-modal-edit-news');
        },
        onSubmitEditNews: async function ()
        {
            const qs = require('qs');
            axios.post(this.$httpPath+'/addscriber/editNick', 
                qs.stringify({
                    _id: this.currentCommunityGuid,
                    relName:this.currentCommunityName,
                    nickName:this.currentCommunityCode
                }),
            )
            .then((response)=>{
                    if(response.status===200)
                    {
                        Vue.$toast.open({
                        message: '更新成功',
                        position: 'bottom-right',
                        type: 'success'
                        });
                        this.refreshGrid();
                        this.CloseEditNews();
                        this.CancelAdd();
                    }
                })
        },
        createLineURL(){
            //this.$bvModal.show('bv-modal-show-url');
            this.$bvModal.hide('bv-modal-add-news');
            //this.currentURL = 'https://notify-bot.line.me/oauth/authorize?response_type=code&scope=notify&response_mode=form_post&state=' + this.currentCommunityCode + '&client_id=OdvneRVOej87cv2iir9tma&redirect_uri=http://35.194.229.108/addscriber/addInfo';
            this.currentURL = this.$httpPath+'/addscriber/reRoute?code='+ this.currentCommunityCode
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