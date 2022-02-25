<template>
    <div>
        <el-container class="main">
            <el-aside :width="tabWidth+'px'">
                <div>
                    <div class="isClossTab" @click="isClossTabFun">
                        <i :class="isCollapse?'el-icon-d-arrow-right':'el-icon-d-arrow-left'" ></i>
                    </div>
                    <el-menu :class="'menu'"
                            :default-active="$route.path"
                            :collapse="isCollapse"
                             class="el-menu-vertical-demo"
                             @open="handleOpen"
                             @close="handleClose"
                             @select="handleSelect"
                             router
                             unique-opened
                             background-color="#545c64"
                             text-color="#fff"
                             active-text-color="#ffd04b"
                    >
                      <el-submenu index="1">
                        <template slot="title">
                          <i class="el-icon-user"></i>
                          <span>註冊資料</span>
                        </template>
                        <el-menu-item-group>
                          <el-menu-item index="/AddClient" style="color: rgb(255, 208, 75)">加入社區</el-menu-item>
                        </el-menu-item-group>
                        <el-menu-item-group>
                          <el-menu-item index="/showQR" style="color: rgb(255, 208, 75)">查詢 QR Code</el-menu-item>
                        </el-menu-item-group>
                      </el-submenu>
    
                      <el-submenu index="3">
                        <template slot="title">
                          <i class="el-icon-document"></i>
                          <span>訊息資料</span>
                        </template>
                        <el-menu-item-group>
                          <el-menu-item index="/SendNotify" style="color: rgb(255, 208, 75)">訊息推播</el-menu-item>
                        </el-menu-item-group>                                                  
                      </el-submenu>    
                       <!-- 
                      <el-submenu index="5">
                        <template slot="title">
                          <i class="el-icon-news"></i>
                          <span>新聞資料</span>
                        </template>
                        <el-menu-item-group>
                          <el-menu-item index="/EditNews" style="color: rgb(255, 208, 75)">編輯新聞</el-menu-item>
                        </el-menu-item-group>
                      </el-submenu>  

                      <el-submenu index="6">
                        <template slot="title">
                          <i class="el-icon-info"></i>
                          <span>系統資訊</span>
                        </template>
                        <el-menu-item-group>
                          <el-menu-item index="/Teacher" style="color: rgb(255, 208, 75)">講師資本資料</el-menu-item>
                        </el-menu-item-group>
                      </el-submenu>   -->
                                                        
                      <el-submenu index="12">
                        <template slot="title">
                          <i class="el-icon-s-shop" ></i>
                          <a href="/" style="color: rgb(255, 208, 75)"><span>首頁</span></a>
                        </template>                        
                      </el-submenu>                      
                    </el-menu>
                </div>
            </el-aside>
            <el-container>
                <el-header class="main-header">
                    <el-dropdown @command="handleCommand">
                        <span class="el-dropdown-link">
                            <img src="../../assets/FCS_Logo.jpg" alt="">
                        </span>
                    </el-dropdown>
                </el-header>
                <el-main>
                    <!-- <el-breadcrumb separator="/" class="crumbs">
                        <el-breadcrumb-item :to="{ path: '/' }">首頁</el-breadcrumb-item>
                        <el-breadcrumb-item>活動管理</el-breadcrumb-item>
                        <el-breadcrumb-item>活動列表</el-breadcrumb-item>
                        <el-breadcrumb-item>活動詳情</el-breadcrumb-item>
                    </el-breadcrumb> -->
                    <div>
                        <router-view></router-view>
                    </div>
                </el-main>
                <!-- <el-footer class="main-footer" height="50px">
                    <p>FIRDI Training Service Website © 2021</p>
                </el-footer> -->
            </el-container>
        </el-container>
    </div>
</template>
<style scoped>
    *{
        padding: 0;
        margin: 0;
    }

</style>
<style scoped lang="scss">
    $header-height:60px;
    $background-color: #545c64;
    $color: #FFF;

    .main{
        height: 100%;
        min-width: 800px;
        min-height: 600px;
        overflow: hidden;

        aside{
            overflow: visible;
            //height: 600px;
            background-color: $background-color;
            color: $color;

            .isClossTab{
                width: 100%;
                height: $header-height;
                cursor: pointer;
                font-size: 30px;
                text-align: center;
                line-height: $header-height;
                font-weight: bold;
                border-right: 1px solid #807c7c;
                box-sizing: border-box;
            }
            .menu {
                width: 100%;
                border-right:0;
                line-height: 300px;

            }

        }

        .main-header {
            background-color: $background-color;
            color: $color;

            .el-dropdown{
                cursor: pointer;
                float: right;
            }
            .el-dropdown-link{

                img{
                    $imgMargin: (($header-height - 50)/2);
                    display:inline-block;
                    width:50px;
                    height: 50px;
                    border-radius: 25px;
                    background-color: #FFF;
                    margin-top: $imgMargin;
                }
            }
        }

        .crumbs {
            margin-bottom: 20px;
        }

        .main-footer{
            text-align: center;
            background-color: $background-color;
            color: $color;
            line-height: 50px;
        }
        .el-submenu .el-menu-item {
          height: 20px;
          line-height: 20px;
        }
        .el-menu-item-group__title {
          padding: 0px !important;
        }
    }

</style>
<script>
import Vue from 'vue';
import Vuex from 'vuex'
Vue.use(Vuex);
    export default {
        data() {
            return {
                isCollapse: false,
                tabWidth: 200,
                test1: 1,
                intelval: null,
            };
        },
        methods: {
            handleSelect(key,keyPath)
            {
              if(key=="1")
                  this.level1="學員資料"
              else if(key=="3")
                  this.level1="課程資料"
              
              if(keyPath=="/ClassLocation")
                this.level2="上課地點清冊"
              else if(keyPath=="/EditClassCat")
                this.level2="課程類別"
            },          
            handleOpen(key, keyPath) {
            },
            handleClose(key, keyPath) {
            },

            isClossTabFun(){
                clearInterval(this.intelval);
                if(!this.isCollapse){
                    this.intelval = setInterval(()=>{
                        if(this.tabWidth<= 64)
                            clearInterval(this.intelval);
                        this.tabWidth -= 1;
                    }, 1);
                }else{
                    this.tabWidth = 200;
                }
                this.isCollapse = !this.isCollapse;
            },
            handleCommand(command) {
                if (command === 'logout') {
                  this.$store.dispatch("logout");
                }
            }            
        }
    }
</script>
