#Inspired by David Fraser tutorial (https://github.com/davidfraser/sqlalchemy-orm-tutorial)
import sqlalchemy

sqlalchemy.__version__

from sqlalchemy import create_engine

dbEngine = create_engine('sqlite:///:memory:', echo=True)
dbEngine.execute("select 1").scalar()
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

from sqlalchemy import Column, Integer, String


class Contact(Base):
    __tablename__ = 'contacts'
    id = Column(Integer, primary_key=True)
    firstName = Column(String)
    lastName = Column(String)
    phoneNumber = Column(String)
    email = Column(String)

    def __init__(self, firstName, lastName, phoneNumber, email):
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email

    def __repr__(self):
        return "<Contact('%s','%s', '%s', '%s')>" % (self.firstName, self.lastName, self.phoneNumber, self.email)


Contact.__table__
Contact.__mapper__

Base.metadata.create_all(dbEngine)

myContact = Contact('Ramin', 'Farhanian', '4254813507', 'rfarhanian@smu.edu')
myContact.firstName
myContact.lastName
myContact.phoneNumber
myContact.email
print 'The id of the contact that has not been persisted yet:', myContact.id

from sqlalchemy.orm import sessionmaker

Session = sessionmaker(bind=dbEngine)
session = Session()

session.add(myContact)

loadedContact = session.query(Contact).filter_by(firstName='Ramin').first()
print "loadedContact is myContact:", loadedContact is myContact
print 'The id of loaded myContact: ', loadedContact.id
print 'loaded myContact str: ', str(loadedContact)

session.add_all([
    Contact('John', 'Smith', '3609963950', 'john.smith@gmail.com'),
    Contact('Anthony', 'Watkins', '3609963951', 'anthony.watkins@hotmail.com'),
    Contact('Edward', 'Legend', '3609963952', 'edward.legend@yahoo.com')
]
)
session.dirty
session.new
session.commit()

print "In Query:"
inQueryResult = session.query(Contact).filter(
    Contact.email.in_(['anthony.watkins@hotmail.com', 'edward.legend@yahoo.com'])).all()

print "In Query result:", inQueryResult

print "Partial result Example:", inQueryResult

for partialResultItem in session.query(Contact.lastName, Contact.email). \
        filter(Contact.firstName != 'John').order_by(Contact.id).all():
    print partialResultItem

print "\nAlias Example:\n"

from sqlalchemy.orm import aliased

contact_alias = aliased(Contact, name='contact_alias')
for row in session.query(contact_alias, contact_alias.firstName).all():
    print row.contact_alias

print "\nFilter Example:\n"

for email, in session.query(Contact.email).filter_by(firstName='John'):
    print email

print "\nNot found Example:\n"

query = session.query(Contact)

from sqlalchemy.orm.exc import NoResultFound

try:
    aContact = query.filter(Contact.id == 68).one()
except NoResultFound, e:
    print e

print "\ndeclarative Query:\n"
watkinsQuery = session.query(Contact).from_statement("SELECT * FROM contacts where email=:email").params(
    email='anthony.watkins@hotmail.com').all()
for resultItem in watkinsQuery:
    print resultItem

print "\ncount Query:\n"
from sqlalchemy import func

count = session.query(func.count('*')).select_from(Contact).scalar()
print count

print "\nRelationship\n"

from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship, backref


class Address(Base):
    __tablename__ = 'addresses'
    id = Column(Integer, primary_key=True)
    address = Column(String, nullable=False)
    title = Column(String, nullable=False)
    contact_id = Column(Integer, ForeignKey('contacts.id'))

    contact = relationship("Contact", backref=backref('addresses', order_by=id))

    def __init__(self, title, address):
        self.title = title
        self.address = address

    def __repr__(self):
        return "<Address('%s')>" % self.address


Base.metadata.create_all(dbEngine)

johnRogers = Contact('John', 'Rogers', '8006013407', 'john.rogers@icloud.com')
johnRogers.addresses

johnRogers.addresses = [
    Address('Work', '4030 NE 109th St, Seattle, WA 98125'),
    Address('Home', '26 NE 106th St, Seattle, WA 98125'),
]

johnRogers.addresses[1]
johnRogers.addresses[1].contact

session.add(johnRogers)
session.commit()

johnRogers = session.query(Contact).filter_by(lastName='Rogers').one()
print johnRogers

print "\nManaged Relationship:\n"

for c, a in session.query(Contact, Address).filter(Contact.id == Address.contact_id).filter(
                Address.address == '26 NE 106th St, Seattle, WA 98125').all():
    print c, a

print "\nJoin:\n"

for result in session.query(Contact).join(Address).filter(Address.title == 'Home').all():
    print result

print "\nCascading:\n"

session.delete(johnRogers)
rogers_count = session.query(Contact).filter_by(lastName='Rogers').count()
print "\nRogers contact is deleted from the database:\n", rogers_count == 0

countResult = session.query(Address).filter(
    Address.address.in_(['4030 NE 109th St, Seattle, WA 98125', '26 NE 106th St, Seattle, WA 98125'])).count()
print "\nDo we still have John Rogers addresses in our system?", countResult != 0
print "\nBut in reality we would like sqlAlchemy to remove dependent records of our contacts as well. That is why we need cascading!\n"

session.rollback()
session.close()

Contact.cascading_addresses = relationship("Address", backref='cascading_contact', cascade="all, delete, delete-orphan")

johnRogers = session.query(Contact).get(5)

print "John", johnRogers

print "\nDeleting John Rogers first address\n"
del johnRogers.cascading_addresses[1]

print "\nLoading the count of all of John Rogers addresses:\n"

result = session.query(Address).filter(
    Address.address.in_(['4030 NE 109th St, Seattle, WA 98125', '26 NE 106th St, Seattle, WA 98125'])).count()

print "\nHow many addresses does John Roger have now?", result

session.rollback()

