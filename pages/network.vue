<template>
  <div>
    <v-row>
      <div>
        <v-container>
          <v-row>
            <v-card class="mx-auto" max-width="344">
              <v-card-text>
                <div>Tag Server Status: {{ apStatus }}</div>
              </v-card-text>
            </v-card>
          </v-row>
        </v-container>
      </div>
    </v-row>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isOpen: false,
      apStatus: null,
    };
  },
  methods: {},
  created: async function () {
    const url = "http://localhost:5000/api/tag/server-status";

    async function fetchApServerStatus() {
      const response = await fetch(url);
      return await response.json();
    }

    this.apStatus = await fetchApServerStatus();
  },
  mounted: function () {},
};
</script>