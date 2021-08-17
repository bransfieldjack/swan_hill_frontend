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

                <v-btn>
                  <v-icon dark>mdi-wrench</v-icon>
                  Configure
                </v-btn>

                <v-toolbar color="#CEDFF4" dense flat>
                  <v-text-field
                    clearable
                    hide-details
                    prepend-icon="mdi-magnify"
                    single-line
                  ></v-text-field>
                </v-toolbar>

                <v-btn>
                  <v-icon large color="orange darken-2">
                    mdi-arrow-right-bold
                  </v-icon>
                  Search
                </v-btn>
              </v-btn-toggle>
            </v-row>
          </v-card-text>
        </v-card>

        <br />

        <div class="gfg">
          <br />
          <br />
          <br />
          <br />
          <v-card class="mx-auto" max-width="544">
            <v-container>
              <NuxtLink to="">
                <v-row>
                  <v-col cols="12" md="2"
                    ><v-img height="100%" src="/VerticalBarcodeGraphic.png"
                  /></v-col>

                  <v-col cols="12" md="10">
                    <div style="border: ridge; height: 100%">
                      <v-row>
                        <v-col cols="12" md="3">
                          <p>Hunky Dory Salt Vinegar 35g</p>
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
                            <span>$3.95</span>
                          </div>
                        </v-col>

                        <v-col cols="12" md="9">
                          <v-img
                            style="padding-top: 70px"
                            height="30%"
                            src="/horiz_barcode.png"
                          />
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
                              ><h2>$3.95</h2>
                              <br
                            /></span>
                            <br />
                          </div>
                        </v-col>
                      </v-row>
                    </div>
                  </v-col>
                </v-row>
              </NuxtLink>
            </v-container>
          </v-card>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  data() {
    return {
      eTagId: null,
      saving: false,
      rules: [
        (value) => !!value || "Required.",
        (value) => (value && value.length >= 6) || "Min 6 characters",
      ],
      addSingleTag: false,
      addTagButton: false,
      tags: [
        { id: 1, name: "product1", price: 10.0 },
        { id: 2, name: "product2", price: 20.0 },
        { id: 3, name: "product3", price: 30.0 },
        { id: 4, name: "product4", price: 40.0 },
        { id: 5, name: "product5", price: 50.0 },
        { id: 6, name: "product6", price: 60.0 },
        { id: 7, name: "product7", price: 70.0 },
      ],
    };
  },
  methods: {
    saveSingleTag: async function () {
      this.saving = true;
      const url = "http://localhost:5000/add/single_tag/";

      // const response = await this.$http.$post(url);
      // return await response.json();

      await this.$axios
        .post(url, {
          ID: this.eTagId,
        })
        .then((response) => {
          console.log(response);

          this.saving = false;
          this.addTagButton = false;
          this.addSingleTag = false;

          alert("eTag Added");
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    fire: function () {
      window.alert("sometext");
    },
  },

  mounted: function () {},
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
