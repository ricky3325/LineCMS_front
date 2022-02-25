<template>
<k-dialog>   
  <div><H4 style="padding-left: 30px;font-weight:bold;color:rgb(0, 61, 88);">課程類別圖片管理</H4></div>            
  <div style="padding:30px">
    <span style="padding-left: 10px;color: blue;font-size: 18px;"><strong>上傳檔案</strong>(Accepted files:png/jpg/bmp)</span>
        <div :style="{ width: '100%' }">
            <upload
                        :auto-upload="false"
                        :default-files="[]"
                        :with-credentials="false"
                        :multiple="false"
                        @beforeupload="onBeforeUpload"
                        @statuschange="onStatusChange"
                        :restrictions="{
                            allowedExtensions: ['.png','.jpg','bmp']
                        }"
                        :save-url="this.$httpPath+'/ClassCatList/UploadFileAsync'">
            </upload>
        </div>  
    <div class="input-group-append"></div>
    <div><button v-on:click="DelImgFile" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px;margin:10px">刪除選擇檔案</button></div>
  <div :class="rootClass">
    <ul :class="`${rootClass}__wrapper`"  class="gallery">
      <li v-for="(dataImage, index) in dataImagesLocal" :key="index" :class="`${rootClass}__item`">
        <div
          :class="classThumbnail(singleSelected.id, dataImage.id, dataImage.disabled)"
          @click="onSelectImage(dataImage)"
          v-if="!isMultiple"
        >
          <img
            :src="dataImage.src"
            :alt="dataImage.alt"
            :id="dataImage.id"
            :height="h"
            :width="w"
            :class="`${rootClass}__img`"
          />

          <label :for="dataImage.id" v-if="useLabel" :class="`${rootClass}__lbl`">{{dataImage.alt}}</label>
        </div>

        <div
          :class="classThumbnailMultiple(dataImage.id, dataImage.disabled)"
          @click="onSelectMultipleImage(dataImage)"
          v-if="isMultiple"
        >
          <img
            :src="dataImage.src"
            :alt="dataImage.alt"
            :id="dataImage.id"
            :height="h"
            :width="w"
            :class="`${rootClass}__img`"
          />

          <label :for="dataImage.id" v-if="useLabel" :class="`${rootClass}__lbl`" style="font-size: 10px">{{dataImage.alt}}</label>
        </div>
      </li>
    </ul>
  </div>
  </div>
 </k-dialog>
</template>

<script>
import axios from 'axios';
import { Upload } from '@progress/kendo-vue-upload';
import Vue from 'vue';
export default {
  name: "CatImg_DialogContainer",
    components: {
        'upload': Upload,
    },  
  props: {
    dataImages: {
      type: Array,
    },
    selectedImages: {
      type: Array,
      default: () => []
    },
    isMultiple: {
      type: Boolean,
      default: false
    },
    useLabel: {
      type: Boolean,
      default: true
    },
    rootClass: {
      type: String,
      default: "vue-select-image"
    },
    activeClass: {
      type: String,
      default: "--selected"
    },
    h: {
      type: String,
      default: "auto"
    },
    w: {
      type: String,
      default: "auto"
    },
    limit: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      singleSelected: {
      id: ""
      },
      multipleSelected: []
    };
  },
  computed: {
    dataImagesLocal: function() {
      return this.dataImages || [];
    }
  },
  mounted() {
    // set initial selectedImage
    this.setInitialSelection();
    this.GetImgFile();
  },
  methods: {
    onStatusChange(event) {
      if(event.response.status==200)
      {
        Vue.$toast.open({
        message: '上傳完成。',
        position: 'bottom-right',
        type: 'success'
        });  
        this.GetImgFile();
      }
    },    
    onBeforeUpload(event) {
      //event.additionalData.description = this.classGroup+";"+this.classID+";"+this.文件說明;
    },   
    isNullOrWhitespace( input ) {
      if (typeof input === 'undefined' || input == null) return true;
      return input.replace(/\s/g, '').length < 1;
    },          
    DelImgFile()
    {
        if(this.isNullOrWhitespace(this.singleSelected.src))
        {
            Vue.$toast.open({
            message: '請先選擇欲刪除的檔案',
            position: 'top',
            type: 'error'
            });  
            return;
        }
        var url = this.singleSelected.src;
        var filename = url.substring(url.lastIndexOf('/')+1);
        axios.delete(this.$httpPath+'/ClassCatList/DelImgFile?fileName='+filename)
        .then((response)=>{
            if(response.status===200)
            {
                  Vue.$toast.open({
                  message: '刪除完成。',
                  position: 'bottom-right',
                  type: 'success'
                  });  
                  this.GetImgFile();
            }
            else{
                  Vue.$toast.open({
                  message: '刪除錯誤。',
                  position: 'top',
                  type: 'error'
                  });                
            }
        })
        .catch((error) => {
                  Vue.$toast.open({
                  message: '刪除錯誤。',
                  position: 'top',
                  type: 'error'
                  });   
          }).finally(() => {
      });  

    },    
    GetImgFile()
    {
        axios.get(this.$httpPath+'/ClassCatList/GetImgFiles')
        .then((response)=>{
            if(response.status===200)
            {
                this.dataImages=response.data;
            }
        }) 
    },
    classThumbnail(selectedId, imageId, isDisabled) {
      const baseClass = `${this.rootClass}__thumbnail`;
      if (isDisabled) {
        return `${baseClass} ${baseClass}--disabled`;
      }
      if (selectedId === imageId) {
        return `${baseClass} ${baseClass}${this.activeClass}`;
      }
      return `${baseClass}`;
    },
    classThumbnailMultiple(id, isDisabled) {
      const baseClass = `${this.rootClass}__thumbnail`;
      const baseMultipleClass = `${baseClass} is--multiple`;
      if (isDisabled) {
        return `${baseMultipleClass} ${baseClass}--disabled`;
      }
      if (this.isExistInArray(id)) {
        return `${baseMultipleClass} ${baseClass}${this.activeClass}`;
      }
      return `${baseMultipleClass}`;
    },
    onSelectImage(objectImage) {
      if (!objectImage.disabled) {
        this.singleSelected = Object.assign({}, this.singleSelected, objectImage);
        this.$emit("update", this.$store.selectedCatImg);
        this.GetImgFile();
      }
    },
    isExistInArray(id) {
      return this.multipleSelected.find(item => {
        return id === item.id;
      });
    },
    removeFromSingleSelected() {
      this.singleSelected = {};
      this.$emit("onselectimage", {});
    },
    removeFromMultipleSelected(id, dontFireEmit) {
      this.multipleSelected = this.multipleSelected.filter(item => {
        return id !== item.id;
      });
      if (!dontFireEmit) {
        this.$emit("onselectmultipleimage", this.multipleSelected);
      }
    },
    resetMultipleSelection() {
      this.multipleSelected = [];
    },
    onSelectMultipleImage(objectImage) {
      if (!objectImage.disabled) {
        if (!this.isExistInArray(objectImage.id)) {
          if (this.limit > 0) {
            if (this.multipleSelected.length < this.limit) {
              this.multipleSelected.push(objectImage);
              this.$emit("onselectmultipleimage", this.multipleSelected);
            } else {
              this.$emit("onreachlimit", this.limit);
            }
          } else {
            this.multipleSelected.push(objectImage);
            this.$emit("onselectmultipleimage", this.multipleSelected);
          }
        } else {
          this.removeFromMultipleSelected(objectImage.id, true);
          this.$emit("onselectmultipleimage", this.multipleSelected);
        }
      }
    },
    setInitialSelection() {
      if (this.selectedImages) {
        if (!this.isMultiple && this.selectedImages.length === 1) {
          this.singleSelected = Object.assign({}, this.selectedImages[0]);
        } else {
          this.multipleSelected = [].concat(this.selectedImages);
        }
      }
    }
  }
};
</script>
<style>
.vue-select-image__wrapper {
    overflow: auto;
    list-style-image: none;
    list-style-position: outside;
    list-style-type: none;
    padding: 0px;
    margin: 0px;
  }
  
  .vue-select-image__item {
    margin: 0px 12px 12px 0px;
    float: left;
  }
  
  .vue-select-image__thumbnail{
    cursor: pointer;
    padding: 6px;
    border: 1px solid #dddddd;
  
    display: block;
    padding: 4px;
    line-height: 20px;
    border: 1px solid #ddd;
  
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
  
    -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.055);
    -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.055);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.055);
  
    -webkit-transition: all 0.2s ease-in-out;
    -moz-transition: all 0.2s ease-in-out;
    -o-transition: all 0.2s ease-in-out;
    transition: all 0.2s ease-in-out;
  }
  
  .vue-select-image__thumbnail--selected{
    background: #0088cc;
  }
  
  .vue-select-image__thumbnail--disabled{
    background: #b9b9b9;
    cursor: not-allowed;
  }
  
  .vue-select-image__thumbnail--disabled > .vue-select-image__img{
    opacity: .5;
  }
  
  .vue-select-image__img{
    -webkit-user-drag: none;
    display: block;
    max-width: 100px;
    margin-right: auto;
    margin-left: auto;
  }
  
  .vue-select-image__lbl{
    line-height: 1.5;
  }
  .row {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: center;
  }
  .gallery li {
      display: inline;
      list-style: none;
      min-width: 150px;
      min-height: 150px;
      float: left;
      margin: 0 10px 10px 0;
      text-align: center;
      FONT-SIZE: 2pt;
  }  
  @media only screen and (min-width: 1200px) {
    .vue-select-image__item {
      margin-left: 30px;
    }
  }