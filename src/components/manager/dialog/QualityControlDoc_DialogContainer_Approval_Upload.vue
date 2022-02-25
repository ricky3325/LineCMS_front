<template>
<k-dialog @close="cancel">
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    班別類別
                    <select class="form-control" style="width: 400px" @change="ClassCat_onChange($event)">
                      <optgroup label="班別類別">
                          <Option v-for="item in this.ClassCatList" 
                                  :value="item" 
                                  :key="item"
                                  >{{ item }}
                          </Option>
                      </optgroup>
                    </select>
                    </label>
                </div>               
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    班別代號
                  <select class="form-control" style="width: 400px" @change="ClassId_onChange($event)">
                      <optgroup label="班別代號">
                          <Option v-for="item in this.ClassIdList" 
                                  :value="item" 
                                  :key="item"
                                  >{{ item }}
                          </Option>
                      </optgroup>
                  </select>   
                    </label>
                </div>
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    文件說明
                  <select class="form-control" style="width: 400px" @change="FileDescription_onChange($event)">
                      <optgroup label="文件說明">
                          <Option v-for="item in this.FileDescription" 
                                  :value="item" 
                                  :key="item"
                                  >{{ item }}
                          </Option>
                      </optgroup>
                  </select>  
                    <k-input
                        style="width:400px"
                        type="text"
                        :name="'主旨'"
                        v-model= "this.主旨"
                    ></k-input>                   
                    </label>
                </div>                                  
                <div :style="{ marginBottom: '1rem' }">
                    <label>上傳檔案</label>
                    <upload
                        :disabled="isDisabled"
                        :auto-upload="false"
                        :default-files="[]"
                        :with-credentials="false"
                        :multiple="false"
                        @beforeupload="onBeforeUpload"
                        :restrictions="{
                            allowedExtensions: ['.doc','docx']
                        }"
                        :save-url="this.$httpPath+'/QualityControlDocApproval/UploadFileAsync'">
                    </upload>
                    <div class="k-form-hint">檔案格式: <strong> doc/docx</strong></div>                   
                </div>              
            <dialog-actions-bar>
                <button
                    class="k-button"
                    @click="cancel"
                >
                    離開
                </button>
            </dialog-actions-bar>
        </k-dialog>
</template>
<script>
import axios from 'axios';
import Vue from 'vue';
import { Dialog, DialogActionsBar } from '@progress/kendo-vue-dialogs';
import { Input } from '@progress/kendo-vue-inputs';
import { Upload } from '@progress/kendo-vue-upload';
export default {
   name:"QualityControlDoc_DialogContainer_Approval_Upload",
   components: {
        'k-dialog': Dialog,
        'dialog-actions-bar': DialogActionsBar,   
        upload: Upload,        
    },
   props: {
      dataItem: Object
  },
  data: function(){
    return {
        ClassCatList:[],
        ClassIdList:[],
        FileDescription:[],
        classGroup:'',
        classID:'',      
        fileItemInEdit: {
            guid:'',
            classGroup:'',
            classCode:'',
            模版檔案名稱:'',
            文件說明:'',
            稽核文件:'',
            稽核狀態:'',
            上傳時間:'',
            收訖時間:'',
            簽核時間:'',
            上傳者:''
        },    
        isDisabled:true,  
    };
  },
  created: function(){
    if(this.$props.dataItem){
      this.fileItemInEdit = this.$props.dataItem;
    }
  },
  mounted() {
        axios.get(this.$httpPath+'/ClassCat/GetClassCats')
            .then((response) => {
                if(response.status==200)
                {
                    this.ClassCatList =  response.data;
                    this.ClassCatList.splice(0, 0, "");                    
                }   
                else
                {
                    Vue.$toast.open({
                    message: '課程類別代碼查詢錯誤。',
                    position: 'top',
                    type: 'error'
                    });   
                }
            })
            .catch((error) => {
                    Vue.$toast.open({
                    message: '課程類別代碼查詢錯誤。',
                    position: 'top',
                    type: 'error'
                    });   
            }).finally(() => {
      });      
      axios.get(this.$httpPath+'/QualityControlDocTemplate/GetTemplateDescription')
            .then((response) => {
                if(response.status==200)
                {
                    this.FileDescription =  response.data;
                    this.FileDescription.splice(0, 0, "");                    
                }   
                else
                {
                    Vue.$toast.open({
                    message: '文件說明查詢錯誤。',
                    position: 'top',
                    type: 'error'
                    });   
                }
            })
            .catch((error) => {
                    Vue.$toast.open({
                    message: '文件說明查詢錯誤。',
                    position: 'top',
                    type: 'error'
                    });   
            }).finally(() => {
      });        
  },  
  methods: {      
      ClassId_onChange(event)
      {
          this.classID = event.target.value;     
          this.checkClass();       
      }, 
      FileDescription_onChange(event)
      {
          this.文件說明 = event.target.value;   
          this.checkClass();  
      },      
      ClassCat_onChange(event)
      {
          this.classGroup = event.target.value
          axios.get(this.$httpPath+'/ClassInfo/GetClassIds', {
              params:{
                  classCat: this.classGroup,
              }})
              .then((response)=>{
                  if(response.status===200)
                  {
                      this.ClassIdList=response.data;
                      this.ClassIdList.splice(0, 0, "");
                  }
              });    
          this.checkClass();                          
      },            
      isNullOrWhitespace( input ) {
        if (typeof input === 'undefined' || input == null) return true;
        return input.replace(/\s/g, '').length < 1;
      },
      checkClass()
      {
        if(this.isNullOrWhitespace(this.classGroup) || this.isNullOrWhitespace(this.classID) || this.isNullOrWhitespace(this.文件說明))
            this.isDisabled=true; 
        else
            this.isDisabled=false; 
      },
      onBeforeUpload(event) {
        event.additionalData.description = this.classGroup+";"+this.classID+";"+this.文件說明;
      },           
      select(fileName)
      {
        this.fileItemInEdit.稽核文件=fileName;
      },
      cancel(){
        this.$emit('CancelUpload');
      },
  },
}

</script>

