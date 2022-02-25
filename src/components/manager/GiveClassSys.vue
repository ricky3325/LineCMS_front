<template>
<div>
<div><H4 style="padding-left: 30px;font-weight:bold;color:rgb(0, 61, 88);">課程開課系統</H4></div>
<div class="form-row" style="padding: 10px;">
<input v-model.number="classNumber" class="form-control" type="number"  min="0" />
<button v-on:click="WriteNum" class="btn btn-primary btn-lg" style="height:30px; font-size:12px">開班</button>
</div>

<div style="padding: 10px;">
        
        <Grid
        ref="grid"
        :style="{height: '500px'}"
        :resizable="true"
        :data-items="students"
        :selected-field="selectedField"
        :columns="columns"
        :pageable="false"
        :total="total"
        @selectionchange="onSelectionChange"
        @headerselectionchange="onHeaderSelectionChange"
        >
        <grid-norecords name="qualifycheck-grid-norecords">
           <div  class="k-loading-mask customPosition"><span class='k-loading-text'></span><div class='k-loading-image'/><div class='k-loading-color'/></div>
        </grid-norecords>          
    </Grid>
</div>

    <vue-toastr ref="toastr"></vue-toastr>         
</div>
</template>

<style scoped src="../../assets/register/bootstrap/css/register.bootstrap.min.css"></style>
<style scoped src="../../assets/register/css/register.css"></style>
<script>
import axios from 'axios';
import { Grid } from '@progress/kendo-vue-grid';
import Vue from 'vue';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import $ from 'jquery';
import '@progress/kendo-ui'
import '@progress/kendo-theme-default/dist/all.css'
import '@progress/kendo-ui/js/messages/kendo.messages.zh-TW.js'

Vue.use(VueToast);
var moment = require('moment');
/* eslint-disable no-debugger, no-console */
export default {
    name:"EmailNotification",
    components: {
        'Grid': Grid,
    },
    mounted() {     
        axios.get(this.$httpPath+'/register/GetClassForGive', {
                params:{
                    classCat: this.$route.query.classCat,//放課Group
                    classID: this.$route.query.classId,
                    classAnnual: "111",
                    currentPage:1,
                    pageSize:this.take
                }})
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.students=response.data;
                        //this.ClassIdList.splice(0, 0, "");
                    }
                });
    },    
    data: function () {
        return {
            classNumber:'',
            ClassCatList:[],
            EmailTypeList:[],
            EmailTypeContent:[],
            ClassIdList:[],
            classGroup:'',
            emailType:'',
            emailContent:'',
            classID:'',

            selectedField: 'selected',
            selectedID: 1,
            columns: [
                { hidden: true, field: 'guid', title: 'guid', width: '100px' },
                { field: 'selected', width: '50px', headerSelectionValue: this.areAllSelected },     
                { field: 'classNo', title: '編班號碼' },           
                { field: 'name', title: '姓名' },
                { field: 'idNumber', title: '身份證字號' },                
                { field: 'qualificationConfirm', title: '資格確認' },
                { field: 'qualificationScore', filter: 'numeric', title: '資格分數' },
                { field: 'enrollStatus', title: '正備取' },
                { field: 'waitingListId', title: '備取序號' },
                { field: 'classGroup', title: '類別代碼' },
                { field: 'classID', title: '班別代號' },
                { field: 'className', title: '課程名稱' },

            ],
            students:[],
            student:
            {
                guid:'',
                selected:'',
                classSeq:'',
                classGroup:'',
                classID:'',
                className:'',
                registerDate:'',
                name:'',
                englishName:'',
                gender:'',
                birthday:'',
                idNumber:'',
                cell:'',
                email:'',
                education:'',
                school:'',
                major:'',
                jobTitle:'',
                job:'',
                qualification:'',
                companyName:'',
                companyId:'',
                companyZIP:'',
                compamyAddress:'',
                companyPhone:'',
                companyPhoneExt:'',
                companyFax:'',
                contactZIP:'',
                contactAddress:'',
                ContactPhone:'',
                ContactPhoneExt:'',
                contactFax:'',
                emergencyName:'',
                emergencyPhone:'',
                emergencyPhoneExt:'',
                emergencyCell:'',
                trainContactName:'',
                trainContactEmail:'',
                trainContactPhone:'',
                trainContactPhoneExt:'',
                trainContactCell:'',
                classLocation:'',
                accommodation:'',
                accommodationDays:'',
                accommodationOptions:'',
                useMeal:'',
                carnivorismVegetarianism:'',
                driveCar:'',
                carID:'',
                moneyAmount:'',
                certificateDate:'',
                registerSeq:'',
                roomID:'',
                moneyTransferDate:'',
                moneyTransferMemo:'',
                bankAccountLast5:'',
                attachmentNumber:'',
                uploadFileNumber:'',
                enrollStatus:'',
                waitingListId:'',
                options:'',
                inputPerson:'',
                inputDateTime:'',
                respondStatus:'',
                respondContent:'',
                respondDateTime:'',
                moneySum:'',
                classHours:'',
                registerOnline:'',
                qualificationConfirm:'',
                qualificationScore:'',
                qualificationDemo:'',
                SendEmail:''                                    
            },
            guid:'',
            errorMessage:"",
            qualification: null,
            qulifyItems:[],      
            files: [],
            progress_value:0,
            progress_max:0,
            testEmail:""
            };
    },
    computed: {
        areAllSelected () {
            return this.students.findIndex(item => item.selected === false) === -1;
        },        
        items () {
            return this.students.map((item) => ({ ...item, selected: item.ProductID === this.selectedID }));
        },
        selectedItem () {
            return this.students.find((item) => item.guid === this.guid);
        },
        // result: {
        //     get: function() {
        //         return this.students.slice(this.skip, this.take + this.skip);
        //     }
        // },
        total () {
            return this.students.totalRows;
        }        
    },
    methods: {
        onHeaderSelectionChange (event) {
            let checked = event.event.target.checked;
            this.students = this.students.map((item) => { return {...item, selected: checked} });
        },
        onSelectionChange (event) {
            event.dataItem[this.selectedField] = !event.dataItem[this.selectedField];
        },        
        refreshData(even){
            axios.get(this.$httpPath+'/register/GetClassForGive', {
                params:{
                    classCat: this.$route.query.classCat,//放課Group
                    classID: this.$route.query.classId,
                    classAnnual: "111",
                    currentPage:1,
                    pageSize:this.take
                }})
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.students=response.data;
                        //this.ClassIdList.splice(0, 0, "");
                        Vue.$toast.open({
                                message: "更新成功",
                                position: 'bottom-right',
                                type: 'success'
                                });
                    }
                });
        },
        ClassId_onChange(event)
        {
            this.classID = event.target.value            
        },          
        onBeforeUpload(event) {
            event.additionalData.description = this.student.classCat+";"+this.student.classID+";"+this.student.idNumber;
            event.additionalData.idNumber = this.student.idNumber;
            event.additionalData.classCat = this.student.classCat;
            event.additionalData.classID = this.student.classID;
        },     
        WriteNum()
        {
            var vm = this;
            //var selectedStudent=[];
            vm.students.data.forEach(function(item, i) {
                if(item.selected===true)
                {
                    axios.get(Vue.prototype.$httpPath+'/register/UpdateClassNumForGive', {
                    params:{
                        userID: item.guid,
                        classNum: vm.classNumber
                    }})
                    .then((response)=>{
                        if(response.status===200)
                        {
                            Vue.$toast.open({
                                message: "更新成功請重新整理頁面",
                                position: 'bottom-right',
                                type: 'success'
                                });
                            //this.students=response.data;
                            //this.ClassIdList.splice(0, 0, "");
                            
                        }
                    });
                }
            });   
            this.refreshData();      
        },
    },
};
</script>
<style>
    @import "../../assets/css/telerik/all.css";
    .k-header {
        font-size: 18px; /* Sets icon size to 32px */
    } 
</style>