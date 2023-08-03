package com.dinastyonline.flutter_contacts_plus

import android.provider.ContactsContract


abstract class ContactsQuery {
    abstract fun getSelection(): String
    abstract fun getSelectionArgs(): List<String>
}



open class ContactsQueryIn(
        private val comparator: String,
        private val values: List<String>
): ContactsQuery() {
    override fun getSelection(): String {
        return "$comparator IN (?)"
    }
    override fun getSelectionArgs(): List<String> {
        return listOf(values.joinToString(", "))
    }
}

open class ContactsQueryEq(
        private val comparator: String,
        private val value: String
): ContactsQuery() {
    override fun getSelection(): String {
        return "$comparator = ?"
    }
    override fun getSelectionArgs(): List<String> {
        return listOf(value)
    }
}

open class ContactsQueryLike(
        private val comparator: String,
        private val value: String
): ContactsQuery() {
    override fun getSelection(): String {
        return "$comparator LIKE ?"
    }
    override fun getSelectionArgs(): List<String> {
        return listOf(value)
    }
}


open class ContactsQueryOr(
        private val queries: List<ContactsQuery>,
): ContactsQuery() {
    override fun getSelection(): String {
        return queries.joinToString(" OR ") { it.getSelection() }
    }
    override fun getSelectionArgs(): List<String> {
        return queries.flatMap { it.getSelectionArgs() }
    }
}


open class ContactsQueryAnd(
        private val queries: List<ContactsQuery>,
): ContactsQuery() {
    override fun getSelection(): String {
        return queries.joinToString(" AND ") { it.getSelection() }
    }
    override fun getSelectionArgs(): List<String> {
        return queries.flatMap { it.getSelectionArgs() }
    }
}
class ContactsQueryByIds(
        private val ids: List<String>
): ContactsQueryIn(
        ContactsContract.Data.CONTACT_ID,
        ids
)

data class ContactsQueryByRawId(
        val id: String
): ContactsQueryEq(
        ContactsContract.Data.RAW_CONTACT_ID,
        id
)

data class ContactsQueryByPhoneNumber(
        val phoneNumber: String
): ContactsQueryOr(
        listOf(
            ContactsQueryLike(ContactsContract.PhoneLookup.NUMBER, phoneNumber),
                ContactsQueryLike(ContactsContract.PhoneLookup.NORMALIZED_NUMBER, phoneNumber)
        )
)


data class ContactsQueryByEmailAddress(
        val emailAddress: String
): ContactsQueryLike(ContactsContract.CommonDataKinds.Email.ADDRESS, emailAddress)



data class ContactsQueryByGroup(
        val groupId: String
):
        ContactsQueryAnd(listOf(
                ContactsQueryEq(ContactsContract.CommonDataKinds.GroupMembership.GROUP_ROW_ID, groupId),
                ContactsQueryEq(ContactsContract.CommonDataKinds.GroupMembership.MIMETYPE, ContactsContract.CommonDataKinds.GroupMembership.CONTENT_ITEM_TYPE)
        ))