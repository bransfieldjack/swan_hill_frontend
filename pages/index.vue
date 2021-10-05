<template>
  <div>
    <v-row>
      <v-col cols="12" md="12">
        <v-card class="mx-auto" fluid style="background-color: #2d3748">
          <v-card-text>
            <v-row>
              <v-btn-toggle tile background-color="#2286EB">
                <v-dialog v-model="addTagButton" width="500">
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn v-bind="attrs" v-on="on">
                      <v-icon large color="orange darken-2">
                        mdi-arrow-up-bold-box-outline
                      </v-icon>
                      Add
                    </v-btn>
                  </template>
                  <v-card>
                    <v-card-title class="text-h5 grey lighten-2">
                      Add an eTag
                    </v-card-title>
                    <br />
                    <v-card-text>
                      <v-container>
                        <v-row no-gutters>
                          <v-col cols="12" md="5">
                            <v-btn
                              @click="addSingleTag = true"
                              block
                              outlined
                              large
                              rounded
                              >Single</v-btn
                            >
                          </v-col>

                          <v-col cols="12" md="2"></v-col>
                          <v-col cols="12" md="5" v-if="addSingleTag == true">
                            <div>
                              <v-text-field
                                label="eTag ID"
                                :rules="rules"
                                v-model="eTagId"
                                hide-details="auto"
                              ></v-text-field>
                              <br />
                              <v-btn color="#4ACB90" @click="saveSingleTag()"
                                >Save</v-btn
                              >
                            </div>

                            <v-overlay :value="saving">
                              <v-progress-circular
                                indeterminate
                                size="64"
                              ></v-progress-circular>
                            </v-overlay>
                          </v-col>
                          <v-col cols="12" md="5" v-if="addSingleTag == false">
                            <v-btn block disabled outlined large rounded
                              >Many</v-btn
                            >
                          </v-col>
                        </v-row>
                      </v-container>
                    </v-card-text>

                    <v-divider></v-divider>

                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn
                        color="primary"
                        text
                        @click="(addTagButton = false), (addSingleTag = false)"
                      >
                        Close
                      </v-btn>
                    </v-card-actions>
                  </v-card>
                </v-dialog>

                <!-- <v-btn>
                  <v-icon dark>mdi-wrench</v-icon>
                  Configure
                </v-btn> -->

                <v-toolbar color="#CEDFF4" dense flat>
                  <v-text-field
                    v-model="search"
                    clearable
                    hide-details
                    prepend-icon="mdi-magnify"
                    single-line
                  ></v-text-field>
                </v-toolbar>

                <v-btn
                  color="#4ACB90"
                  v-if="search != null"
                  @click="tag_search()"
                >
                  <v-icon large color="orange darken-2">
                    mdi-arrow-right-bold
                  </v-icon>
                  Search
                </v-btn>
                <v-btn color="#8250DE" @click="reload()">
                  <v-icon large color="orange darken-2"> mdi-refresh </v-icon>
                </v-btn>
              </v-btn-toggle>
            </v-row>
          </v-card-text>
        </v-card>

        <br />

        <v-overlay :value="saving">
          <v-progress-circular indeterminate size="64"></v-progress-circular>
        </v-overlay>

        <!-- {{ tags }} -->

        <div class="gfg">
          <br />
          <br />
          <br />
          <br />

          <v-layout row wrap>
            <v-card
              v-for="(item, index) in tags.slice(0, 15)"
              :key="index"
              class="mx-auto mb-6"
              max-width="444"
            >
              <v-container>
                <a href="#" @click="edit(item)">
                  <v-row>
                    <v-col cols="12" md="2"
                      ><v-img height="100%" src="/VerticalBarcodeGraphic.png"
                    /></v-col>

                    <v-col cols="12" md="10">
                      <div style="border: ridge; height: 100%">
                        <v-row>
                          <v-col cols="12" md="3">
                            <p>{{ item.description }}</p>
                            <div
                              style="
                                height: 60%;
                                background-color: #629aeb;
                                color: white;
                                text-align: center;
                                font-size: 22px;
                              "
                            >
                              <span>WAS</span>
                              <span>${{ item.price }}</span>
                            </div>
                          </v-col>

                          <v-col cols="12" md="9">
                            <v-img
                              style="padding-top: 70px"
                              height="30%"
                              src="/horiz_barcode.png"
                            />
                            <span style="color: #1f8e3d"
                              >Barcode: #{{ item.tagBarCode }}</span
                            >
                            <br />

                            <div
                              style="
                                line-height: 100%;
                                background-color: #f4521d;
                                color: white;
                                text-align: center;
                                font-size: 22px;
                              "
                            >
                              <br />

                              <span><h1>NOW</h1></span>
                              <br />
                              <span
                                ><h2>${{ item.price }}</h2>
                                <br
                              /></span>
                              <br />
                            </div>
                          </v-col>
                        </v-row>
                      </div>
                    </v-col>
                  </v-row>
                </a>
              </v-container>
            </v-card>
          </v-layout>
        </div>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-dialog
        v-model="edit_tag"
        fullscreen
        hide-overlay
        transition="dialog-bottom-transition"
      >
        <v-card>
          <v-toolbar dark color="#2D3848">
            <v-toolbar-title
              >ID: {{ this.tag_being_edited.tagBarCode }}</v-toolbar-title
            >

            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn icon dark @click="edit_tag = false">
                <v-icon>mdi-close</v-icon>
              </v-btn>
            </v-toolbar-items>
          </v-toolbar>

          <v-container>
            <v-row>
              <v-col cols="12" md="4">
                <br />
                <br />
                <br />
                <v-card class="mx-auto mb-6" max-width="444">
                  <v-container>
                    <v-row>
                      <v-col cols="12" md="2"
                        ><v-img height="100%" src="/VerticalBarcodeGraphic.png"
                      /></v-col>

                      <v-col cols="12" md="10">
                        <div style="border: ridge; height: 100%">
                          <v-row>
                            <v-col cols="12" md="3">
                              <p>{{ this.tag_being_edited.description }}</p>
                              <div
                                style="
                                  height: 60%;
                                  background-color: #629aeb;
                                  color: white;
                                  text-align: center;
                                  font-size: 22px;
                                "
                              >
                                <span>WAS</span>
                                <span>${{ this.tag_being_edited.price }}</span>
                              </div>
                            </v-col>

                            <v-col cols="12" md="9">
                              <v-img
                                style="padding-top: 70px"
                                height="30%"
                                src="/horiz_barcode.png"
                              />
                              <span style="color: #1f8e3d"
                                >Barcode: #{{
                                  this.tag_being_edited.tagBarCode
                                }}</span
                              >
                              <br />

                              <div
                                style="
                                  line-height: 100%;
                                  background-color: #f4521d;
                                  color: white;
                                  text-align: center;
                                  font-size: 22px;
                                "
                              >
                                <br />

                                <span><h1>NOW</h1></span>
                                <br />
                                <span
                                  ><h2>${{ this.tag_being_edited.price }}</h2>
                                  <br
                                /></span>
                                <br />
                              </div>
                            </v-col>
                          </v-row>
                        </div>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-card>
                <br />
                <v-container>
                  <v-row>
                    <v-col cols="12" md="2"></v-col>
                    <v-col cols="12" md="10">
                      <v-list three-line subheader>
                        <v-subheader>Template:</v-subheader>

                        <v-list-item>
                          <v-list-item-action>
                            <v-select
                              :items="template_items"
                              label="Tag Template"
                              solo
                            ></v-select>
                          </v-list-item-action>
                        </v-list-item>
                      </v-list>
                    </v-col>
                  </v-row>
                </v-container>
              </v-col>
              <v-col cols="12" md="4">
                <v-container>
                  <v-row>
                    <v-col cols="12" md="2"></v-col>
                    <v-col cols="12" md="8">
                      <v-list three-line subheader>
                        <br />
                        <br />

                        <v-form ref="form">
                          <!-- sku -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>SKU: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.sku }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.sku"
                            >
                            </v-text-field>
                          </div>

                          <!-- description -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>Description: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.description }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.description"
                            >
                            </v-text-field>
                          </div>

                          <!-- category -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>Category: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.category }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.category"
                            >
                            </v-text-field>
                          </div>

                          <!-- department -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>Department: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.department }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.department"
                            >
                            </v-text-field>
                          </div>
                        </v-form>
                      </v-list>
                    </v-col>
                    <v-col cols="12" md="2"></v-col>
                  </v-row>
                </v-container>
              </v-col>
              <v-col cols="12" md="4">
                <v-container>
                  <v-row>
                    <v-col cols="12" md="2"></v-col>
                    <v-col cols="12" md="8">
                      <v-list three-line subheader>
                        <br />
                        <br />

                        <v-form ref="form">
                          <!-- sku -->
                          <!-- gst -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>GST: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.gst }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.gst"
                            >
                            </v-text-field>
                          </div>

                          <!-- soh -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>SOH: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.soh }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.soh"
                            >
                            </v-text-field>
                          </div>

                          <!-- price -->
                          <div>
                            <p style="color: #6aa4e7">
                              <span><b>Price: </b></span>
                              <span
                                ><p style="color: #cccccc">
                                  {{ this.tag_being_edited.price }}
                                </p></span
                              >
                            </p>

                            <v-text-field
                              clearable
                              outlined
                              required
                              v-model="updatedTag.price"
                            >
                            </v-text-field>
                          </div>
                          <br />
                          <br />
                          <v-btn
                            color="#4ACB90"
                            class="mr-4"
                            @click="updateTag()"
                          >
                            Update
                          </v-btn>
                          <v-btn
                            color="#D33344"
                            class="mr-4"
                            @click="deleteTag()"
                          >
                            Delete
                          </v-btn>
                        </v-form>
                      </v-list>
                    </v-col>
                    <v-col cols="12" md="2"></v-col>
                  </v-row>
                </v-container>
              </v-col>
            </v-row>
          </v-container>

          <br />
        </v-card>
      </v-dialog>
    </v-row>
  </div>
</template>

<script>
export default {
  data() {
    return {
      updatedTag: {
        id: 0,
        tagBarCode: " ",
        sku: 0,
        description: " ",
        category: " ",
        department: " ",
        gst: " ",
        soh: 0,
        price: 0,
      },
      edit_values: null,
      template_items: ["sale", "standard"],
      tag_being_edited: 0,
      edit_tag: false,
      search: null,
      eTagId: null,
      saving: false,
      rules: [
        (value) => !!value || "Required.",
        (value) => (value && value.length >= 6) || "Min 6 characters",
      ],
      addSingleTag: false,
      addTagButton: false,
      tags: [],
    };
  },
  methods: {
    reload: function () {
      // reload the app

      location.reload();
    },
    tag_search: async function () {
      // Search for a single tag

      this.saving = true;
      var tag = await fetch(
        "http://localhost:5000/api/tag/" + this.search
      ).then((res) => res.json());
      this.tags = [];
      this.tags[0] = tag;
      this.saving = false;
    },
    retrieveTags: async function () {
      // retrieve all tags from the API

      this.tags = await fetch("http://localhost:5000/api/tag/all").then((res) =>
        res.json()
      );
    },
    updateTag: async function () {
      console.log("this.updatedTag is: ");
      console.log(this.updatedTag);

      console.log("this.tag_being_edited is: ");
      console.log(this.tag_being_edited);

      this.saving = true;
      const headers = {
        "Content-Type": "application/json",
        accept: "application/json",
      };
      const url = "http://localhost:5000/api/tag/update";

      await this.$axios
        .post(
          url,
          {
            tagBarCode: this.tag_being_edited.tagBarCode,
            sku: parseInt(this.updatedTag.sku),
            description: this.updatedTag.description,
            category: String(this.updatedTag.category),
            department: String(this.updatedTag.department),
            gst: String(this.updatedTag.gst),
            soh: parseInt(this.updatedTag.soh),
            price: parseInt(this.updatedTag.price),
          },
          {
            headers: headers,
          }
        )
        .then((response) => {
          console.log(response);
          this.saving = false;

          alert(
            "Tag: " +
              String(this.tag_being_edited.tagBarCode) +
              " Successfully Updated!"
          );
          location.reload();
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    deleteTag: async function () {
      console.log("tag being edited is: ");
      console.log(this.tag_being_edited);
      this.saving = true;
      const url = "http://localhost:5000/api/tag/delete";

      await this.$axios
        .post(url, {
          tagBarCode: this.tag_being_edited.tagBarCode,
          sku: 0,
          description: "string",
          category: "string",
          department: "string",
          gst: "string",
          soh: 0,
          price: 0,
        })
        .then((response) => {
          console.log(response);
          this.saving = false;

          alert("eTag Deleted");
          location.reload();
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    saveSingleTag: async function () {
      // add one new single tag

      this.saving = true;
      const url = "http://localhost:5000/api/tag/add";

      await this.$axios
        .post(url, {
          id: 0,
          tagBarCode: this.eTagId,
          sku: 0,
          description: "string",
          category: "string",
          department: "string",
          gst: "string",
          soh: 0,
          price: 0,
        })
        .then((response) => {
          console.log(response);

          this.saving = false;
          this.addTagButton = false;
          this.addSingleTag = false;

          alert("eTag Added");
          location.reload();
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    fire: function () {
      alert("sometext");
    },
    edit: function (tag) {
      this.edit_tag = true;
      this.tag_being_edited = tag;
      this.updatedTag = tag;
      console.log(tag);
    },
  },
  mounted: function () {
    this.retrieveTags();
  },
};
</script>

<style>
span {
  display: inline-block;
  vertical-align: middle;
  line-height: 18px; /* <-- adjust this */
}

.toolbar {
  width: 80%;
  left: 10%;
}

div.gfg {
  /* margin: 5px; */
  /* padding: 5px; */
  background-color: #edf2f6;
  width: 100%;
  height: 1000px;
  overflow: auto;
  text-align: justify;
}

.title {
  font-family: "Quicksand", "Source Sans Pro", -apple-system, BlinkMacSystemFont,
    "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}

/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0, 0, 0); /* Fallback color */
  background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto; /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button */
.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}
</style>
